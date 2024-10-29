#!/bin/bash

##########################################################
#           DevSecOps Days Paris 2024 - JFTD-112
##########################################################

# Fail the script on any command failure and ensure unset variables raise an error
set -euo pipefail

# Enable logging
LOG_FILE="./script.log"
exec 3>&1 1>>"${LOG_FILE}" 2>&1  # Log stdout and stderr to the log file and keep stdout on fd 3

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $*" >&3
}

error_exit() {
  log "ERROR: $1"
  exit 1
}

###############################################
# Prepare your local environment
###############################################

# Load environment variables
log "Loading environment variables..."
if [[ -f ".env" ]]; then
  source .env || error_exit "Failed to source .env file"
else
  error_exit ".env file not found!"
fi

# Check required variables
required_vars=("JFROG_PLATFORM" "token" "PROJECT_NAME" "PROJECT_DESCRIPTION" "PROJECT_ID" "SCRIPT_DIR")
for var in "${required_vars[@]}"; do
  [[ -z "${!var:-}" ]] && error_exit "Environment variable $var is not set or empty"
done

################################################################################################################
## LAB 1 - Repository and project provisioning
################################################################################################################

log "Configuring JFrog CLI..."
jf config add dsod --url=https://"$JFROG_PLATFORM" --access-token="$token" --interactive=false || error_exit "Failed to configure dsod"
jf config add dsod-edge --url=https://"$JFROG_EDGE" --access-token="$edge_token" --interactive=false || error_exit "Failed to configure dsod-edge"

jf c use dsod || error_exit "Failed to set dsod as default"

log "Creating JFrog project..."
curl -s -X POST -H "Authorization: Bearer $token" -H 'Content-Type: application/json' \
    -d "{\"PROJECT_DESCRIPTION\":\"$PROJECT_DESCRIPTION\", \"display_name\":\"$PROJECT_NAME\", \"project_key\":\"$PROJECT_ID\"}" \
    https://"$JFROG_PLATFORM"/access/api/v1/projects || error_exit "Failed to create JFrog project"

# Create repositories in JPD and Edge
create_repository() {
  local repo_type=$1
  log "Creating $repo_type repositories..."
  jf rt curl -X PUT /api/v2/repositories/batch --header 'Content-Type: application/json' \
      -d @"$SCRIPT_DIR/env-provisioning/repositories/repository-$repo_type.json" || error_exit "Failed to create $repo_type repositories"
}

for repo_type in local remote virtual; do
  create_repository "$repo_type"
done

log "Creating Edge repositories..."
jf rt curl -X PUT /api/v2/repositories/batch --header 'Content-Type: application/json' \
    -d @"$SCRIPT_DIR/env-provisioning/repositories/repository-local-edge.json" --server-id dsod-edge || error_exit "Failed to create Edge local repositories"

jf rt curl -X PUT /api/v2/repositories/batch --header 'Content-Type: application/json' \
    -d @"$SCRIPT_DIR/env-provisioning/repositories/repository-virtual-edge.json" --server-id dsod-edge || error_exit "Failed to create Edge virtual repositories"

################################################################################################################
## LAB 2 - JFrog CLI Build integration
################################################################################################################

log "Configuring build integration for Gradle..."
cd "$SCRIPT_DIR/back/webservice" || error_exit "Directory $SCRIPT_DIR/back/webservice not found"

jf gradlec --repo-resolve="${PROJECT_ID}-app-gradle-virtual" \
           --server-id-resolve=dsod \
           --repo-deploy="${PROJECT_ID}-app-gradle-virtual" \
           --deploy-ivy-desc=false \
           --deploy-maven-desc=true \
           --server-id-deploy=dsod || error_exit "Failed to configure Gradle CLI"

export JFROG_CLI_EXTRACTORS_REMOTE=dsod/extractors

log "Running Gradle build..."
jfrog gradle clean artifactoryPublish -b build.gradle --info --refresh-dependencies \
    --build-name="${PROJECT_ID}-gradle-jftd-112" --build-number="$BUILD_NUMBER" --project="$PROJECT_ID" || error_exit "Gradle build failed"

log "Publishing Gradle build info..."
jf rt bp "${PROJECT_ID}-gradle-jftd-112" "$BUILD_NUMBER" --project="$PROJECT_ID" || error_exit "Failed to publish Gradle build info"

log "Preparing Docker build..."
cd "$SCRIPT_DIR/back/CI/Docker" || error_exit "Directory $SCRIPT_DIR/back/CI/Docker not found"
sed "s/registry/$JFROG_PLATFORM\/${PROJECT_ID}-app-docker-virtual/g" jfrog-Dockerfile > Dockerfile || error_exit "Failed to update Dockerfile"

BASE_IMAGE=$(awk '/^FROM/ {print $2}' Dockerfile)
[[ -z "$BASE_IMAGE" ]] && error_exit "Base image not found in Dockerfile"

log "Pulling base image..."
jf rt dpl "$BASE_IMAGE" "${PROJECT_ID}-app-docker-virtual" --build-name="${PROJECT_ID}-docker-jftd-112" \
    --build-number="$BUILD_NUMBER" --module=app || error_exit "Failed to deploy base image"

log "Building Docker image..."
docker build . -t "$JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual/${PROJECT_ID}-jfrog-docker-app:$BUILD_NUMBER" \
    -f Dockerfile --build-arg REGISTRY="$JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual" --build-arg BASE_TAG="$BUILD_NUMBER" || error_exit "Docker build failed"

log "Pushing Docker image..."
jf rt dp "$JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual/${PROJECT_ID}-jfrog-docker-app:$BUILD_NUMBER" \
    "${PROJECT_ID}-app-docker-virtual" --build-name="${PROJECT_ID}-docker-jftd-112" --build-number="$BUILD_NUMBER" \
    --module=app --project="$PROJECT_ID" || error_exit "Failed to push Docker image"

log "Publishing Docker build info..."
jf rt bp "${PROJECT_ID}-docker-jftd-112" "$BUILD_NUMBER" --project="$PROJECT_ID" || error_exit "Failed to publish Docker build info"

# Log creation and upload of Helm Chart
log "Creating and uploading Helm chart..."
cp -r "$SCRIPT_DIR/docker-app-chart-template" "$SCRIPT_DIR/docker-app-chart" || error_exit "Failed to copy Helm chart template"
cd "$SCRIPT_DIR/docker-app-chart" || error_exit "Directory $SCRIPT_DIR/docker-app-chart not found"

sed -i "s/0.1.1/0.1.$BUILD_NUMBER/" Chart.yaml || error_exit "Failed to update Chart.yaml"
sed -i "s/latest/$BUILD_NUMBER/g" values.yaml || error_exit "Failed to update values.yaml"

jf rt bce "${PROJECT_ID}-helm-jftd-112" "$BUILD_NUMBER" --project="$PROJECT_ID" || error_exit "Failed to create Helm build info"
helm package . || error_exit "Failed to package Helm chart"
jf rt u 'docker-app-chart-*.tgz' "${PROJECT_ID}-app-helm-virtual" --build-name="${PROJECT_ID}-helm-jftd-112" --build-number="$BUILD_NUMBER" \
    --module=app --project="$PROJECT_ID" || error_exit "Failed to upload Helm chart"
jf rt bp "${PROJECT_ID}-helm-jftd-112" "$BUILD_NUMBER" --project="$PROJECT_ID" || error_exit "Failed to publish Helm build info"

# Log release bundle operations
log "Creating and promoting release bundles..."
jf rbc --spec="$SCRIPT_DIR/lab-4/build-spec.json" "${PROJECT_ID}-rb-jftd-111" "$APP_VERSION" \
    --spec-vars="project-id=$PROJECT_ID" --signing-key="LoanDeptKey" --project="$PROJECT_ID" || error_exit "Failed to create release bundle"

for env in DEV RC PROD; do
  log "Promoting to $env..."
  jf rbp "${PROJECT_ID}-rb-jftd-111" "$APP_VERSION" "$env" --signing-key="LoanDeptKey" --project="$PROJECT_ID" --sync=true || error_exit "Failed to promote to $env"
done

log "Distributing release bundle..."
curl -s -X POST -H "Authorization: Bearer $token" -H 'Content-Type: application/json' \
    -d @"$SCRIPT_DIR/env-provisioning/jfrog-distribution/distribution-spec.json" \
    https://"$JFROG_PLATFORM"/lifecycle/api/v2/distribution/distribute/"${PROJECT_ID}-rb-jftd-111/$APP_VERSION"?project=dsodparis || error_exit "Release bundle distribution failed"

log "Script completed successfully."

##########################################################
#           DevSecOps Days Paris 2024 - JFTD-112
##########################################################


###############################################
#Prepare your local environment
###############################################

# Load environment variables
source .env

################################################################################################################
## LAB 1 - Repository and project provisioning
################################################################################################################

# Configure CLI in the main JPD
jf config add dsod --url=https://$JFROG_PLATFORM --access-token=$token --interactive=false

# Configure CLI in the Artifactory Edge
jf config add dsod-edge --url=https://$JFROG_EDGE --access-token=$edge_token --interactive=false

# Updating with a new token (example)
jf config edit dsod-edge --access-token=$edge_token --interactive=false

# Check existing configuration
jf c show

# Make it default
jf c use dsod

# Create project
curl -XPOST -H "Authorization: Bearer ${token}" -H 'Content-Type:application/json' https://$JFROG_PLATFORM/access/api/v1/projects -d "{\"PROJECT_DESCRIPTION\":\"${PROJECT_DESCRIPTION}\", \"display_name\":\"${PROJECT_NAME}\", \"project_key\":\"${PROJECT_ID}\"}"

# Create all repositories in the main Artifactory JPD
# TODO : Update the template to use the project ID
#sed "s/app/${PROJECT_ID}-app/g" $SCRIPT_DIR/env-provisioning/repositories/repo-conf-creation-main-template.yaml > $SCRIPT_DIR/env-provisioning/repositories/repo-conf-creation-main.yaml

# Local repositories
jf rt curl -XPUT /api/v2/repositories/batch --header 'Content-Type: application/json' -d @${SCRIPT_DIR}/env-provisioning/repositories/repository-local.json
# Remote repisoties
jf rt curl -XPUT /api/v2/repositories/batch --header 'Content-Type: application/json' -d @${SCRIPT_DIR}/env-provisioning/repositories/repository-remote.json
# Virtual repositories
jf rt curl -XPUT /api/v2/repositories/batch --header 'Content-Type: application/json' -d @${SCRIPT_DIR}/env-provisioning/repositories/repository-virtual.json

# Create all repositories in the Artifactory Edge Node
# Local repositories EDGE1
jf rt curl -XPUT /api/v2/repositories/batch --header 'Content-Type: application/json' -d @${SCRIPT_DIR}/env-provisioning/repositories/repository-local-edge.json --server-id dsod-edge
# Virtual repositories EDGE2
jf rt curl -XPUT /api/v2/repositories/batch --header 'Content-Type: application/json' -d @${SCRIPT_DIR}/env-provisioning/repositories/repository-virtual-edge.json --server-id dsod-edge

# Adding builds to the Xray indexing process
#curl -u$ADMIN_USER:$ADMIN_PASSWORD -X POST -H "content-type: application/json"  https://$JFROG_PLATFORM/xray/api/v1/binMgr/builds -T $SCRIPT_DIR/lab-3/indexed-builds.json
# TODO : Define a pattern based on the build name (manually in the UI)

################################################################################################################
## LAB 2 - JFROG CLI Build integration
################################################################################################################

# CD into the java src code folder 
cd $SCRIPT_DIR/back/webservice

# Configure cli for gradle
# Todo disable ivy descriptors
jf gradlec --repo-resolve=${PROJECT_ID}-app-gradle-virtual --server-id-resolve=dsod --repo-deploy=${PROJECT_ID}-app-gradle-virtual --deploy-ivy-desc=false --deploy-maven-desc=true --server-id-deploy=dsod

# Local proxy for our build info extractor (for both Maven and Gradle)
export JFROG_CLI_EXTRACTORS_REMOTE=dsod/extractors

# Gradle Build Run
jfrog gradle clean artifactoryPublish -b build.gradle --info --refresh-dependencies --build-name=${PROJECT_ID}-gradle-jftd-112 --build-number=$BUILD_NUMBER --project=${PROJECT_ID}

# Publishing Build info
jf rt bp ${PROJECT_ID}-gradle-jftd-112 $BUILD_NUMBER --project=${PROJECT_ID}

# Docker App Build
# Updating dockerfile with JFrog Platform URL
cd $SCRIPT_DIR/back/CI/Docker

# Update the docker file to define the registry for the base image
sed "s/registry/${JFROG_PLATFORM}\/${PROJECT_ID}-app-docker-virtual/g" jfrog-Dockerfile > Dockerfile

# Reading the docker file and identifying the base image
export BASE_IMAGE=$(cat Dockerfile | grep "^FROM" | awk '{print $2}' )

# Pulling fhe base image
jf rt dpl $BASE_IMAGE ${PROJECT_ID}-app-docker-virtual --build-name=${PROJECT_ID}-docker-jftd-112 --build-number=$BUILD_NUMBER --module=app

# Download war file dependency
#jf rt dl "${PROJECT_ID}-app-gradle-virtual/*/webservice*.war" war/ --props="stage=staging" --build=dosd-gradle/$BUILD_NUMBER --build-name=${PROJECT_ID}-docker-jftd-112 --build-number=$BUILD_NUMBER --module=java-app --flat=true
jf rt dl "${PROJECT_ID}-app-gradle-virtual/*/webservice*.war" war/ --build=${PROJECT_ID}-gradle-jftd-112/$BUILD_NUMBER --build-name=${PROJECT_ID}-docker-jftd-112 --build-number=$BUILD_NUMBER --module=java-app --flat=true
# Run docker build
docker build . -t $JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual/${PROJECT_ID}-jfrog-docker-app:$BUILD_NUMBER  -f Dockerfile --build-arg REGISTRY=$JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual --build-arg BASE_TAG=$BUILD_NUMBER

# Push the image
# Present a slideck during the docker push (this can take several minutes)
jf rt dp $JFROG_PLATFORM/${PROJECT_ID}-app-docker-virtual/${PROJECT_ID}-jfrog-docker-app:$BUILD_NUMBER ${PROJECT_ID}-app-docker-virtual --build-name=${PROJECT_ID}-docker-jftd-112 --build-number=$BUILD_NUMBER --module=app --project=${PROJECT_ID}

# Publish the docker build
jf rt bp ${PROJECT_ID}-docker-jftd-112 $BUILD_NUMBER --project=${PROJECT_ID}

#Searching for the base image of my docker build
## what base image has been used
jf rt s --spec="${SCRIPT_DIR}/lab-2/filespec-aql-dependency-search.json" --spec-vars="build-name=${PROJECT_ID}-docker-jftd-112;build-number=$BUILD_NUMBER"

#Promote the docker build to release candidate
#jf rt bpr ${PROJECT_ID}-docker-jftd-112 $BUILD_NUMBER ${PROJECT_ID}-app-docker-rc-local --status="release candidate" --copy=true --props="maintainer=hza;stage=staging;appnmv=$APP_ID/$APP_VERSION"

# cd into helm chart repo
cp -r $SCRIPT_DIR/docker-app-chart-template $SCRIPT_DIR/docker-app-chart
cd $SCRIPT_DIR/docker-app-chart

sed -ie 's/0.1.1/0.1.'"$BUILD_NUMBER"'/' ./Chart.yaml
sed -ie 's/latest/'"$BUILD_NUMBER"'/g' ./values.yaml

jf rt bce ${PROJECT_ID}-helm-jftd-112 $BUILD_NUMBER --project=${PROJECT_ID}

# Reference the docker image as helm build dependency
# Important: to do > fetch from virtual, filter based on application name and version
jf rt dl ${PROJECT_ID}-app-docker-virtual/${PROJECT_ID}-jfrog-docker-app/$BUILD_NUMBER/manifest.json --build-name=${PROJECT_ID}-helm-jftd-112 --build-number=$BUILD_NUMBER --module=app --project=${PROJECT_ID}

# package the helm chart 
helm package .

# upload the helm chart
jf rt u 'docker-app-chart-*.tgz' ${PROJECT_ID}-app-helm-virtual --build-name=${PROJECT_ID}-helm-jftd-112 --build-number=$BUILD_NUMBER --module=app --project=${PROJECT_ID}

# publish the helm build
jf rt bp ${PROJECT_ID}-helm-jftd-112 $BUILD_NUMBER --project=${PROJECT_ID}

# Release bundle creation
jf rbc --spec=$SCRIPT_DIR/lab-4/build-spec.json ${PROJECT_ID}-rb-jftd-111 $APP_VERSION  --spec-vars="project-id=$PROJECT_ID" --signing-key="LoanDeptKey" --project=${PROJECT_ID}

# Release bundle promotion to DEV
jf rbp ${PROJECT_ID}-rb-jftd-111 $APP_VERSION DEV --signing-key="LoanDeptKey" --project=${PROJECT_ID} --sync=true

# Release bundle promotion to RC
jf rbp ${PROJECT_ID}-rb-jftd-111 $APP_VERSION RC --signing-key="LoanDeptKey" --project=${PROJECT_ID} --sync=true

# Release bundle promotion to PROD
jf rbp ${PROJECT_ID}-rb-jftd-111 $APP_VERSION PROD --signing-key="LoanDeptKey" --project=${PROJECT_ID} --sync=true

# Release bundle Distribution
curl -XPOST -H "Authorization: Bearer ${token}" -H 'Content-Type:application/json' https://$JFROG_PLATFORM/lifecycle/api/v2/distribution/distribute/${PROJECT_ID}-rb-jftd-111/$APP_VERSION?project=dsodparis" -d @${SCRIPT_DIR}/env-provisioning/jfrog-distribution/distribution-spec.json

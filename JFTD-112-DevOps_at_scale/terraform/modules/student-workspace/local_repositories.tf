#### DOCKER ####

resource "artifactory_local_docker_v2_repository" "docker_dev_local" {
  key = "${var.project_key}-app-docker-dev-local"
  project_environments = ["DEV"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_docker_v2_repository" "docker_rc_local" {
  key = "${var.project_key}-app-docker-rc-local"
  project_environments = ["RC"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_docker_v2_repository" "docker_prod_local" {
  key = "${var.project_key}-app-docker-prod-local"
  project_environments = ["PROD"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

#### GRADLE ####

resource "artifactory_local_gradle_repository" "gradle-dev-local" {
  key = "${var.project_key}-app-gradle-dev-local"
  project_environments = ["DEV"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_gradle_repository" "gradle-rc-local" {
  key = "${var.project_key}-app-gradle-rc-local"
  project_environments = ["RC"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_gradle_repository" "gradle-prod-local" {
  key = "${var.project_key}-app-gradle-prod-local"
  project_environments = ["PROD"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}


#### HELM ####

resource "artifactory_local_helm_repository" "helm-dev-local" {
  key = "${var.project_key}-app-helm-dev-local"
  project_environments = ["DEV"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_helm_repository" "helm-rc-local" {
  key = "${var.project_key}-app-helm-rc-local"
  project_environments = ["RC"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_local_helm_repository" "helm-prod-local" {
  key = "${var.project_key}-app-helm-prod-local"
  project_environments = ["PROD"]
  project_key = var.project_key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}
resource "artifactory_virtual_docker_repository" "docker-virtual" {
  key = "${var.project_key}-app-docker-virtual"
  project_key = var.project_key
  project_environments = ["PROD"]

  repositories = [
    artifactory_local_docker_v2_repository.docker_dev_local.key,
    artifactory_local_docker_v2_repository.docker_rc_local.key,
    artifactory_local_docker_v2_repository.docker_prod_local.key,
    artifactory_remote_docker_repository.docker-remote.key
  ]

  default_deployment_repo = artifactory_local_docker_v2_repository.docker_dev_local.key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_virtual_gradle_repository" "gradle-virtual" {
  key = "${var.project_key}-app-gradle-virtual"
  project_key = var.project_key
  project_environments = ["PROD"]

  repositories = [
    artifactory_local_gradle_repository.gradle-dev-local.key,
    artifactory_local_gradle_repository.gradle-rc-local.key,
    artifactory_local_gradle_repository.gradle-prod-local.key,
    artifactory_remote_gradle_repository.gradle-remote.key
  ]

  default_deployment_repo = artifactory_local_gradle_repository.gradle-dev-local.key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_virtual_helm_repository" "helm-virtual" {
  key = "${var.project_key}-app-helm-virtual"
  project_key = var.project_key
  project_environments = ["PROD"]

  repositories = [
    artifactory_local_helm_repository.helm-dev-local.key,
    artifactory_local_helm_repository.helm-rc-local.key,
    artifactory_local_helm_repository.helm-prod-local.key,
    artifactory_remote_helm_repository.helm-remote.key
  ]

  default_deployment_repo = artifactory_local_helm_repository.helm-dev-local.key

  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}
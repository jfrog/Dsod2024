resource "artifactory_local_docker_v2_repository" "docker_prod_local_aus" {
  provider = artifactory.aus
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  key = "${each.value.project_key}-app-docker-prod-local"
  project_environments = ["PROD"]
}

resource "artifactory_local_helm_repository" "helm-prod-local_aus" {
  provider = artifactory.aus
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  key = "${each.value.project_key}-app-helm-prod-local"
  project_environments = ["PROD"]
}

resource "artifactory_local_docker_v2_repository" "docker_prod_local_hk" {
  provider = artifactory.hk
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  key = "${each.value.project_key}-app-docker-prod-local"
  project_environments = ["PROD"]
}

resource "artifactory_local_helm_repository" "helm-prod-local_hk" {
  provider = artifactory.hk
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  key = "${each.value.project_key}-app-helm-prod-local"
  project_environments = ["PROD"]
}
resource "artifactory_remote_docker_repository" "docker-remote" {
  key = "${var.project_key}-app-docker-remote"
  project_key = var.project_key
  url = "https://registry-1.docker.io"
  project_environments = ["DEV"]
  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_remote_gradle_repository" "gradle-remote" {
  key = "${var.project_key}-app-gradle-remote"
  project_key = var.project_key
  url = "https://repo1.maven.org/maven2/"
  project_environments = ["DEV"]
  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_remote_helm_repository" "helm-remote" {
  key = "${var.project_key}-app-helm-remote"
  project_key = var.project_key
  url = "https://storage.googleapis.com/kubernetes-charts"
  project_environments = ["DEV"]
  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}

resource "artifactory_remote_generic_repository" "generic-remote" {
  key = "${var.project_key}-extractors"
  project_key = var.project_key
  url = "https://oss.jfrog.org/artifactory/oss-release-local"
  project_environments = ["DEV"]
  lifecycle {
    ignore_changes = [
      project_key
    ]
  }
}
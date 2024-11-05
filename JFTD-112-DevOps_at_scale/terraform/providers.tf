terraform {
  required_providers {
    artifactory = {
      source = "jfrog/artifactory"
      version = "12.3.1"
    }
    project = {
      source = "jfrog/project"
      version = "1.9.0"
    }
    xray = {
      source  = "jfrog/xray"
      version = "2.13.0"
    }
    missioncontrol = {
      source = "jfrog/mission-control"
      version = "1.1.0"
    }
    platform = {
      source = "jfrog/platform"
      version = "1.15.1"
    }
  }
}

provider "artifactory" {
  url = "${var.jfrog_url}/artifactory"
  access_token = var.access_token
}

provider "artifactory" {
  alias = "aus"
  url = "${var.aus_edge_url}/artifactory"
  access_token = var.aus_access_token
}

provider "artifactory" {
  alias = "hk"
  url = "${var.hk_edge_url}/artifactory"
  access_token = var.hk_access_token
}

provider "project" {
  url = "${var.jfrog_url}/artifactory"
  access_token = var.access_token
}

provider "project" {
  alias = "secondary"
  url = "${var.secondary_jpd_url}/artifactory"
  access_token = var.secondary_access_token
}

provider "xray" {
  url          = "${var.jfrog_url}/xray"
  access_token = var.access_token
}

provider "missioncontrol" {
  url          = var.jfrog_url
  access_token = var.access_token
}

provider "platform" {
  url          = var.jfrog_url
  access_token = var.access_token
}
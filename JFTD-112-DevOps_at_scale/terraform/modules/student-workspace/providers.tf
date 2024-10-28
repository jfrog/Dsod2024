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
  }
}
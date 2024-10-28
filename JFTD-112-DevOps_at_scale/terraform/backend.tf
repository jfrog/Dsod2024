terraform {
  backend "remote" {
    hostname = "soleng.jfrog.io"
    organization = "maxenceb-tf-dsod-prod"
    workspaces {
      name = "dsod"
    }
  }
}

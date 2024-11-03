variable "jfrog_url" {
  description = "URL of the JFrog platform"
  type = string
}

variable "access_token" {
  description = "JFrog access token to deploy infrastructure"
  type = string
}

variable "hk_access_token" {
  description = "JFrog access token for the HK edge"
  type = string
}

variable "aus_access_token" {
  description = "JFrog access token for the AUS edge"
  type = string
}

variable "secondary_access_token" {
  description = "JFrog access token of the secondary JPD"
  type = string
}

variable "projects" {
  description = "List of JFrog project to create for students"
  type = list(
    object({
      project_key = string
      display_name = string
    })
  )
}

variable "temporary_password" {
  description = "Temporary password for users"
  type = string
}

variable "paring_token_edge_aus" {
  description = "Temporary paring token"
  type = string
}

variable "aus_edge_url" {
  description = "URL of the AUS Artifactory edge node"
  type = string
}

variable "pairing_token_edge_hk" {
  description = "Temporary paring token"
  type = string
}

variable "hk_edge_url" {
  description = "URL of the HK Artifactory edge node"
  type = string
}

variable "pairing_token_secondary_jpd" {
  description = "Temporary paring token"
  type = string
}

variable "secondary_jpd_url" {
  description = "URL of the second JPD"
  type = string
}

variable "oidc_repository_name" {
  description = "Name of the github repository for the OIDC integration"
  type = string
}

variable "oidc_token_username" {
  description = "Username of the token spec for the OIDC integration"
  type = string
}
variable "jfrog_url" {
  description = "URL of the JFrog platform"
  type = string
}

variable "access_token" {
  description = "JFrog access token to deploy infrastructure"
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
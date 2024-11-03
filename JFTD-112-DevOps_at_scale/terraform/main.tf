module "project" {
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  source = "./modules/student-workspace"

  project_key = each.value.project_key
  display_name = each.value.display_name
}

resource "artifactory_user" "users" {
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  name = each.value.project_key
  password = var.temporary_password
  email = "${each.value.project_key}@jfrog.com"
  admin = true
  profile_updatable = true
  disable_ui_access = false
}

resource "project" "project_second" {
  provider = project.secondary
  for_each = { for idx, config in var.projects : config["project_key"] => config}

  key  = each.value.project_key
  display_name = each.value.display_name
  description = "Student Project"
  admin_privileges {
    index_resources  = true
    manage_members   = true
    manage_resources = true
  }
}
resource "project" "this" {
  key  = var.project_key
  display_name = var.display_name
  description = var.description
  admin_privileges {
    index_resources  = true
    manage_members   = true
    manage_resources = true
  }
}
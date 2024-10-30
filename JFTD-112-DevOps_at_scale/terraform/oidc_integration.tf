resource "platform_oidc_configuration" "configuration" {
  name          = "dsod-oidc"
  issuer_url    = "https://token.actions.githubusercontent.com"
  provider_type = "GitHub"
}


resource "platform_oidc_identity_mapping" "github_integration" {
  name          = "repository-name"
  description   = "Generate an access token for a particular Github repository"
  claims_json   = jsonencode({
    "repository": var.oidc_repository_name
  })
  priority      = 1
  provider_name = platform_oidc_configuration.configuration.name
  token_spec    = {
    username = var.oidc_token_username
    scope    = "applied-permissions/admin"
    audience = "*@*"
    expires_in = 7200
  }
}
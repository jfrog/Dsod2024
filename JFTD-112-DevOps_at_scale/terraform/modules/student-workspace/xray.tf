resource "xray_security_policy" "min_critical" {
  name = "${var.project_key}_critical_severity"
  description = "Security policy on critical vulnerabilities"
  type = "security"
  project_key = var.project_key

  rule {
    name = "critical_rume"
    priority = 1

    criteria {
      min_severity = "Critical"
      fix_version_dependant = false
    }

    actions {
      block_release_bundle_distribution = false
      block_release_bundle_promotion = false
      fail_build = false
      notify_deployer = false
      notify_watch_recipients = false
      create_ticket_enabled = false

      block_download {
        unscanned = false
        active = false
      }
    }
  }
}

resource "xray_watch" "watch" {
  name = "${var.project_key}_stable_release"
  description = "Watch for stable release bundles"
  active = true
  project_key = var.project_key

  watch_resource {
    type = "all-releaseBundlesV2"
  }

  assigned_policy {
    name = xray_security_policy.min_critical.name
    type = "security"
  }
}
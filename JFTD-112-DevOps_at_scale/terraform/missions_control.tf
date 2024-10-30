resource "missioncontrol_jpd" "dsodedgeaus" {
  name     = "dsodedgeaus"
  url      = var.aus_edge_url
  token    = var.paring_token_edge_aus

  location = {
    city_name = "azure-australiaeast"
    country_code = "AU"
    latitude = 35.2802
    longitude = 149.1310
  }

  tags = []
}

resource "missioncontrol_jpd" "dsodedgehk" {
  name     = "dsodedgehk"
  url      = var.hk_edge_url
  token    = var.pairing_token_edge_hk

  location = {
    city_name = "gcp-asia-east2"
    country_code = "HK"
    latitude = 22.3193
    longitude = 114.1694
  }

  tags = []
}

resource "missioncontrol_jpd" "dsodmultisite2" {
  name     = "dsodmultisite2"
  url      = var.secondary_jpd_url
  token    = var.pairing_token_secondary_jpd

  location = {
    city_name = "New York City"
    country_code = "US"
    latitude = 40.7128
    longitude = 74.0060
  }

  tags = []
}

resource "missioncontrol_access_federation_mesh" "mesh-topology" {
  ids = [
    "JPD-1",
    missioncontrol_jpd.dsodmultisite2.id,
    missioncontrol_jpd.dsodedgeaus.id,
    missioncontrol_jpd.dsodedgehk.id
  ]
  entities = ["USERS", "GROUPS", "PERMISSIONS", "TOKENS"]

  lifecycle {
    ignore_changes = [
      ids,
      entities
    ]
  }
}
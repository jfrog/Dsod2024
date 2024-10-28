resource "mission-control_jpd" "dsodmultisite2" {
  name     = "dsodmultisite2"
  url      = "https://dsodmultisite2.jfrog.io/"
  token    = ""

  location = {
    city_name = "New York City"
    country_code = "US"
  }
}

resource "mission-control_jpd" "dsodedgeaus" {
  name     = "dsodedgeaus"
  url      = "https://dsodedgeaus.jfrog.io/"
  token    = ""

  location = {
    city_name = "azure-australiaeast"
    country_code = "AU"
  }
}

resource "mission-control_jpd" "dsodedgehk" {
  name     = "dsodedgehk"
  url      = "https://dsodedgehk.jfrog.io/"
  token    = ""

  location = {
    city_name = "gcp-asia-east2"
    country_code = "HK"
  }
}

resource "google_gke_hub_feature" "asm_feature" {
  name     = "servicemesh"
  location = "global"
  project  = var.project_id
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "asm_feature_member" {
  for_each   = module.fleet-hub
  location   = "global"
  feature    = google_gke_hub_feature.asm_feature.name
  membership = each.value.cluster_membership_id
  project    = var.project_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta
}


resource "google_gke_hub_feature_membership" "asm_config_feature_member" {
  location   = "global"
  feature    = google_gke_hub_feature.asm_feature.name
  membership = module.config-hub.cluster_membership_id
  project    = var.project_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta
}

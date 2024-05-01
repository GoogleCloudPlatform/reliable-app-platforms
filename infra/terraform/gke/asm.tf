
resource "google_gke_hub_feature" "asm_feature" {
  name     = "servicemesh"
  location = "global"
  project  = var.project_id
}

resource "google_gke_hub_feature_membership" "asm_feature_member" {
  for_each   = module.fleet-hub
  location   = each.value.location
  feature    = google_gke_hub_feature.asm_feature.name
  membership = each.value.cluster_membership_id
  project    = var.project_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
}


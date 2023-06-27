resource "google_gke_hub_feature" "gke-config-mci" {
  name = "multiclusteringress"
  location = "global"
  project = var.project_id
  spec {
    multiclusteringress {
      config_membership = "projects/${var.project_id}/locations/global/memberships/${module.config-hub.cluster_membership_id}"
    }
  }
  provider = google-beta
}

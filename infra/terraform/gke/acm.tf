resource "google_gke_hub_feature" "acm_feature" {
  name     = "configmanagement"
  location = "global"
  project  = var.project_id
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "acm_feature_member" {
  for_each   = module.fleet-hub
  location   = "global"
  feature    = google_gke_hub_feature.acm_feature.name
  membership = each.value.cluster_membership_id
  project    = var.project_id
  configmanagement {
    version = "1.15.1"
    config_sync {
      git {
        sync_repo   = "https://source.developers.google.com/p/${var.project_id}/r/config"
        secret_type = "none"
        # secret_type = "gcpserviceaccount"
        # gcp_service_account_email = "sa@project-id.iam.gserviceaccount.com"
      }
    }
  }
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "acm_config_feature_member" {
  location   = "global"
  feature    = google_gke_hub_feature.acm_feature.name
  membership = module.config-hub.cluster_membership_id
  project    = var.project_id
  configmanagement {
    version = "1.15.1"
    config_sync {
      git {
        sync_repo   = "https://source.developers.google.com/p/${var.project_id}/r/config"
        secret_type = "none"
      }
    }
  }
  provider = google-beta
}
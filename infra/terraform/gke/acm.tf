module "service_account" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.0"
  project_id = var.project_id
  prefix     = "configsync"
  names      = ["sa"]
  project_roles = [
    "${var.project_id}=>roles/source.reader",
  ]
}

resource "google_gke_hub_feature" "acm_feature" {
  name     = "configmanagement"
  location = "global"
  project  = var.project_id
}

resource "google_gke_hub_feature_membership" "acm_feature_member" {
  for_each   = module.fleet-hub
  location   = each.value.location
  feature    = google_gke_hub_feature.acm_feature.name
  membership = each.value.cluster_membership_id
  project    = var.project_id
  configmanagement {
    version = "1.16.3"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo                 = "https://source.developers.google.com/p/${var.project_id}/r/config"
        secret_type               = "gcpserviceaccount"
        gcp_service_account_email = module.service_account.email
      }
    }
  }
  depends_on = [module.service_account]
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  prefix        = "config-sync"
  names         = ["sa"]
  project_roles = [
    "${var.project_id}=>roles/source.reader",
  ]
}

module "workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_gcp_sa = true
  name                = module.service_accounts.service_account.account_id
  project_id          = var.project_id
  annotate_k8s_sa     = true
  use_existing_k8s_sa = true
  cluster_name        = module.gke[0].name
  location            = module.gke[0].location
  namespace           = "config-management-system"
  k8s_sa_name         = "root-reconciler"
  depends_on = [ google_gke_hub_feature_membership.acm_feature_member ]
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
    version = "1.15.1"
    config_sync {
          source_format = "unstructured"
      git {
        sync_repo   = "https://source.developers.google.com/p/${var.project_id}/r/config"
        secret_type = "gcpserviceaccount"
        gcp_service_account_email = module.service_accounts.emails_list[0]
      }
    }
  }
}

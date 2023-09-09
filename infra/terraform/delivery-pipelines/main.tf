
locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
  config_info   = data.terraform_remote_state.gke.outputs.config-clusters
  substitutions = merge([{
    for index, item in local.clusters_info :
    "GKE_PROD${index + 1}_NAME" => item.name
    }
    , {
      for index, item in local.clusters_info :
      "GKE_PROD${index + 1}_LOCATION" => item.region
    }
    ,
    {
      "GKE_CONFIG_NAME"   = local.config_info.name
      "GKE_CONFIG_LOCATION" = local.config_info.region
      "GKE_CONFIG_REGION" = local.config_info.region
      "SPANNER_REGION" = local.config_info.region
      "CLOUDSQL_REGION" = local.config_info.region
      "PROD_MCI_GCLB_IP" = data.google_compute_global_address.mci_address.address

    }]
  ...)
}

resource "google_clouddeploy_target" "target" {
  for_each = { for i, v in local.clusters_info : i => v }
  location = var.pipeline_location
  name     = "target-${each.value.name}"

  gke {
    cluster = each.value.id
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_delivery_pipeline" "primary" {
  for_each = toset(var.service_names)
  location = var.pipeline_location
  name     = "${each.value}-pipeline"

  description = "${each.value} service delivery pipeline for global (g) model"
  project     = var.project_id

  serial_pipeline {

    dynamic "stages" {
      for_each = google_clouddeploy_target.target
      content {
        profiles  = ["prod"]
        target_id = stages.value.target_id
      }
    }
  }
  provider = google-beta
}
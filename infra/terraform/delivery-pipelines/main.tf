
locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
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
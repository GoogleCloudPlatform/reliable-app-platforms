
locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
}

resource "google_clouddeploy_target" "target" {
  for_each = { for i, v in local.clusters_info : i => v }
  location = each.value.region
  name     = "target-${each.value.name}"

  gke {
    cluster = each.value.id
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_delivery_pipeline" "primary" {
  location = google_clouddeploy_target.target[0].location
  name     = "${var.service_name}-pipeline"

  description = "${var.service_name} service delivery pipeline for global (g) model"
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
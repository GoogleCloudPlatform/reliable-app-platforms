
locals {
  clusters_info = jsondecode(data.google_storage_bucket_object_content.cluster_info.content)
  target_SZ = var.archetype == "SZ"  ? [local.clusters_info[var.zone_index[0]]] :null
  target_APZ = var.archetype == "APZ"  ? [local.clusters_info[var.zone_index[0]], local.clusters_info[var.zone_index[1]]] :null
  target_MZ = var.archetype == "MZ"  ? [local.clusters_info[var.zone_index[0]], local.clusters_info[var.zone_index[1]], local.clusters_info[var.zone_index[2]]] :null
  apr_indices = var.archetype == "APR" ? [var.region_index[0]*3+0, var.region_index[0]*3+1, var.region_index[0]*3+2, var.region_index[1]*3+0, var.region_index[1]*3+1, var.region_index[1]*3+2] : null
  target_APR = var.archetype == "APR" ? [local.clusters_info[local.apr_indices[0]], local.clusters_info[local.apr_indices[1]], local.clusters_info[local.apr_indices[2]],  local.clusters_info[local.apr_indices[3]], local.clusters_info[local.apr_indices[4]], local.clusters_info[local.apr_indices[5]]] :null
  ir_indices = var.archetype == "IR" ? [var.region_index[0]*3+0, var.region_index[0]*3+1, var.region_index[0]*3+2, var.region_index[1]*3+0, var.region_index[1]*3+1, var.region_index[1]*3+2] : null
  target_IR = var.archetype == "IR" ? [local.clusters_info[local.ir_indices[0]], local.clusters_info[local.ir_indices[1]], local.clusters_info[local.ir_indices[2]],  local.clusters_info[local.ir_indices[3]], local.clusters_info[local.ir_indices[4]], local.clusters_info[local.ir_indices[5]]] :null
  target_G = var.archetype == "G"  ? local.clusters_info:null

  targets = coalescelist(local.target_SZ,local.target_APZ, local.target_MZ, local.target_APR, local.target_IR, local.target_G)
}

data "google_storage_bucket_object_content" "cluster_info" {
  name   = "platform-values/clusters.json"
  bucket = var.project_id
}

resource "google_clouddeploy_target" "target" {
  for_each = { for i, v in local.targets : i => v }
  location = var.pipeline_location
  name     = "target-${var.service_name}-${each.value.name}"

  gke {
    cluster = each.value.id
  }

  project          = var.project_id
  require_approval = false
}

resource "google_clouddeploy_delivery_pipeline" "primary" {
  location = var.pipeline_location
  name     = lower("${var.service_name}-pipeline")

  description = "Service delivery pipeline for the service ${var.service_name}."
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
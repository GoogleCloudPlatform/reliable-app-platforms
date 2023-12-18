locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
  ip_address = data.terraform_remote_state.gclb.outputs.ip_address

}

resource "google_storage_bucket_object" "cluster_info" {
  name   = "platform-values/clusters.json"
  content = jsonencode(local.clusters_info)
  bucket = var.project_id
}

resource "google_storage_bucket_object" "lb_info" {
  name   = "platform-values/gclb.json"
  content = jsonencode(local.ip_address)
  bucket = var.project_id
}
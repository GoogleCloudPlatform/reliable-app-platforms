locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
}

resource "google_storage_bucket_object" "cluster_info" {
  name   = "clusters.json"
  content = jsonencode(local.clusters_info)
  bucket = var.project_id
}
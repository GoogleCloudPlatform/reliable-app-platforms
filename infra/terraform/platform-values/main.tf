locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
  zone_clusters_info = {
    for index,item in local.clusters_info:
      item.zones[0] => item
  }
}

resource "google_storage_bucket_object" "cluster_info" {
  name   = "platform-values/clusters.json"
  content = jsonencode(local.clusters_info)
  bucket = var.project_id
}
resource "google_storage_bucket_object" "zone_cluster_info" {
  name   = "platform-values/zone_clusters.json"
  content = jsonencode(local.zone_clusters_info)
  bucket = var.project_id
}
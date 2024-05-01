locals{
    zone-clusters-info = {
    for index,item in local.fleet-clusters:
      item.zones[0] => item
  }
}

resource "google_storage_bucket_object" "cluster_info" {
  name   = "platform-values/clusters.json"
  content = jsonencode(local.fleet-clusters)
  bucket = var.project_id
}
resource "google_storage_bucket_object" "zone_cluster_info" {
  name   = "platform-values/zone_clusters.json"
  content = jsonencode(local.zone-clusters-info)
  bucket = var.project_id
}

resource "google_storage_bucket_object" "config_cluster_info" {
  name   = "platform-values/config_cluster.json"
  content = jsonencode(local.config-clusters)
  bucket = var.project_id
}
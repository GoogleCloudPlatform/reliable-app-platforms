output "fleet-clusters" {
  value = [
    for cluster in module.gke : {
      name   = cluster.name
      id     = cluster.cluster_id
      region = cluster.region
      zones  = cluster.zones
    }
  ]
}

output "config-clusters" {
  value = {
    name   = module.gke-config-cluster.name
    id     = module.gke-config-cluster.cluster_id
    region = module.gke-config-cluster.region
    zones  = module.gke-config-cluster.zones
  }
}


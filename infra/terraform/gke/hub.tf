locals{
  fleet-clusters =   [
    for cluster in module.gke : {
      name   = cluster.name
      id     = cluster.cluster_id
      region = cluster.region
      zones  = cluster.zones
    }
  ]
  config-clusters = [{
    name   = module.gke-config-cluster.name
    id     = module.gke-config-cluster.cluster_id
    region = module.gke-config-cluster.region
    zones  = module.gke-config-cluster.zones
  }]
 
 all-clusters = concat(local.fleet-clusters, local.config-clusters)

}

module "fleet-hub" {
  for_each        = {for i,v in local.all-clusters: i=>v}
  source          = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  version         = "28.0.0"
  project_id      = var.project_id
  location        = each.value.region
  cluster_name    = each.value.name
  membership_name = each.value.name
  depends_on      = [module.gke, module.gke-config-cluster]
}

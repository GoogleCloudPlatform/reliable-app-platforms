module "fleet-hub" {
  for_each        = module.gke
  source          = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  version         = "27.0.0"
  project_id      = var.project_id
  location        = each.value.location
  cluster_name    = each.value.name
  membership_name = each.value.name
  depends_on      = [module.gke]
}

module "config-hub" {
  source          = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  version         = "27.0.0"
  project_id      = var.project_id
  location        = module.gke-config-cluster.location
  cluster_name    = module.gke-config-cluster.name
  membership_name = module.gke-config-cluster.name
  depends_on      = [module.gke-config-cluster]
}

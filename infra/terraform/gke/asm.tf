
# TODO: Not working. using local providers in modules prevents the use of for_each. Need to find a way to dynamically generate providers 
# module "fleet-asm" {
#   for_each          =  module.gke
#   source            = "./k8s_provider"
#   project_id        = var.project_id
#   ca_certificate    = each.value.ca_certificate
#   endpoint          = each.value.endpoint
#   cluster_name      = each.value.name
#   cluster_location  = each.value.location
#   enable_cni        = true
# }

# module "config-asm" {
#   source            = "./k8s_provider"
#   project_id        = var.project_id
#   ca_certificate    = module.gke-config-cluster.ca_certificate
#   endpoint          = module.gke-config-cluster.endpoint
#   cluster_name      = module.gke-config-cluster.name
#   cluster_location  = module.gke-config-cluster.location
# }

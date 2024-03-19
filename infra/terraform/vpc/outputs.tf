output "network" { value = module.vpc.network }
output "project_id" { value = module.vpc.project_id }
output "network_name" { value = module.vpc.network_name }
output "subnets" { value = module.vpc.subnets }
output "subnets_ips" { value = module.vpc.subnets_ips }
output "subnets_names" { value = module.vpc.subnets_names }
output "subnets_regions" { value = module.vpc.subnets_regions }
output "subnets_secondary" { value = local.secondary_subnets }
output "fleet_clusters_info" { value = var.fleets}
output "config_cluster_info" { value =  var.gke_config}



data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket  = var.project_id
    prefix  = "tfstate/vpc"
  }
}

locals {
    cluster_info = flatten([
        for item in data.terraform_remote_state.vpc.outputs.clusters_info: [
            for index in range(lookup(item, "num_clusters", 1)): {
                env = item.env
                region = item.region
                subnet_name = item.subnet.name
                cluster_index = index
            }
        ]
    ])
    zone_suffix = ["a", "b", "c"]
    single_zone = ["a"]

}

# module "gke" {
#   for_each = {for i,v in local.cluster_info: i=>v}
#   source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
#   project_id                 = var.project_id
#   name                       = "${each.value.env}-${each.value.region}-${each.value.cluster_index}"
#   regional                   = false
#   zones                      = ["${each.value.region}-${local.zone_suffix[each.value.cluster_index]}"]
#   network                    = "vpc"
#   subnetwork                 = each.value.subnet_name
#   ip_range_pods              = "${each.value.region}-pod-cidr-${each.value.cluster_index}"
#   ip_range_services          = "${each.value.region}-svc-cidr-${each.value.cluster_index}"
#   horizontal_pod_autoscaling = true
# }

module "gke" {
  for_each =  {for i,v in local.single_zone: i=>v}
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  project_id                 = var.project_id
  name                       = "cluster-${each.value}"
  regional                   = false
  zones                      = ["us-central1-${each.value}"]
  network                    = "vpc"
  subnetwork                 = each.value
  ip_range_pods              = "pod-cidr-${each.value}"
  ip_range_services          = "svc-cidr-${each.value}"
  horizontal_pod_autoscaling = true
}

# data "google_client_config" "default" {}

# # provider "kubernetes" {
# #   for_each =  {for i,v in local.single_zone: i=>v}
# #   host                   = "https://${module.gke[each.value].endpoint}"
# #   token                  = data.google_client_config.default.access_token
# #   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# # }
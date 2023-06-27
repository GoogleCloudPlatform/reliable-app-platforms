# TODO: 
# 1: Should they be regional with a single zone (1 cluster per zone per region)?

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
}

# module "gke" {
#   for_each = {for i,v in local.cluster_info: i=>v}
#   source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
#   project_id                 = var.project_id
#   name                       = "${each.value.env}-${each.value.region}-${each.value.cluster_index}"
#   regional                   = true 
#   region                     = each.value.region
#   zones                      = ["${each.value.region}-${local.zone_suffix[each.value.cluster_index]}"]
#   network                    = "vpc"
#   subnetwork                 = each.value.subnet_name
#   ip_range_pods              = "${each.value.region}-pod-cidr-${each.value.cluster_index}"
#   ip_range_services          = "${each.value.region}-svc-cidr-${each.value.cluster_index}"
#   horizontal_pod_autoscaling = true
# }

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-public-cluster"
  project_id                 = var.project_id
  name                       = "test-us-central1-0"
  regional                   = true 
  region                     = "us-central1"
  zones                      = ["us-central1-a"]
  network                    = "vpc"
  subnetwork                 = "us-central1"
  ip_range_pods              = "us-central1-pod-cidr-0"
  ip_range_services          = "us-central1-svc-cidr-0"
  horizontal_pod_autoscaling = true
}


data "google_client_config" "default" {}



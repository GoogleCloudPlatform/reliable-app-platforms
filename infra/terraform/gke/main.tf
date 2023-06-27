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
}

# module "gke" {
#   source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
#   project_id                 = var.project_id
#   name                       = "gke-test-1"
#   region                     = "us-central1"
#   zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
#   network                    = "vpc-01"
#   subnetwork                 = "us-central1-01"
#   ip_range_pods              = "us-central1-01-gke-01-pods"
#   ip_range_services          = "us-central1-01-gke-01-services"
#   horizontal_pod_autoscaling = true
#   filestore_csi_driver       = false
#   enable_private_endpoint    = true
#   enable_private_nodes       = true
#   master_ipv4_cidr_block     = "10.0.0.0/28"

# }
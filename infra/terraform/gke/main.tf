# TODO: 
# 1: Should they be regional with a single zone (1 cluster per zone per region)?
# 2: Should they be public or private clusters?
# 3: Lookup gke.random_shuffle.available_zones, see whether zones can be setup from there.
# 4: ASM and ACM require the k8s provider be created for each cluster. Need to figure out how to do this dynamically.
#    This is a known limitation of creating configs in GKE clusters read here: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/673

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket  = var.project_id
    prefix  = "tfstate/vpc"
  }
}

locals {
    fleet_clusters_info = flatten([
        for item in data.terraform_remote_state.vpc.outputs.fleet_clusters_info: [
            for index in range(lookup(item, "num_clusters", 1)): {
                env = item.env
                region = item.region
                subnet_name = item.subnet.name
                cluster_zone = "${item.region}-${local.zone_suffix[index]}"
                cluster_name = "${item.env}-${item.region}-${index}"
                pod_cidr_name = "${item.region}-pod-cidr-${index}"
                svc_cidr_name = "${item.region}-svc-cidr-${index}"
                network = data.terraform_remote_state.vpc.outputs.network.network_name
            }
        ]
    ])

    config_cluster_info =  {
                env = data.terraform_remote_state.vpc.outputs.config_cluster_info.env
                region = data.terraform_remote_state.vpc.outputs.config_cluster_info.region
                subnet_name = data.terraform_remote_state.vpc.outputs.config_cluster_info.subnet.name
                cluster_name = "config-${data.terraform_remote_state.vpc.outputs.config_cluster_info.region}"
                pod_cidr_name = "${data.terraform_remote_state.vpc.outputs.config_cluster_info.subnet.name}-pods"
                svc_cidr_name = "${data.terraform_remote_state.vpc.outputs.config_cluster_info.subnet.name}-svcs"
                network = data.terraform_remote_state.vpc.outputs.network.network_name

        }

    zone_suffix = ["a", "b", "c"]
}




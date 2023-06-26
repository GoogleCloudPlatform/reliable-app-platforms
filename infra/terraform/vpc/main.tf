module "vpc" {
  source       = "terraform-google-modules/network/google"
#   version =
  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = local.primary_subnets

# TODO: Take subnets from the "vpc" module and make this more specific
  firewall_rules = [{
    name        = "allow-all-10"
    description = "Allow Pod to Pod connectivity for multi-cluster GKE"
    direction   = "INGRESS"
    ranges      = concat([
    for item in flatten([for fleet in var.fleets: local.secondary_subnets[fleet.subnet.name]]): item.ip_cidr_range
  ], local.flattened_primary_subnets)
    allow = [{
      protocol = "tcp"
      ports    = ["0-65535"]
    }]
  }]
}

locals {
  secondary_subnets = merge({
    for fleet in var.fleets :
    fleet.subnet.name => concat(
      [
        for num in range(fleet.num_clusters) : {
          range_name    = "${fleet.subnet.name}-private-ipv4cidr-${num}"
          ip_cidr_range = cidrsubnet(fleet.subnet.cidr, 11, num + 2000)
      }],
      [
        for num in range(fleet.num_clusters) : {
          range_name    = "${fleet.subnet.name}-svc-cidr-${num}"
          ip_cidr_range = cidrsubnet(fleet.subnet.cidr, 7, num + 96)
      }],
      [for num in range(fleet.num_clusters) : {
        range_name    = "${fleet.subnet.name}-pod-cidr-${num}"
        ip_cidr_range = cidrsubnet(fleet.subnet.cidr, 2, num+1)
      }]
    )}, 
    {
    "${var.gke_config.subnet.name}" = [
      {
        range_name    = var.gke_config.subnet.ip_range_pods_name
        ip_cidr_range = var.gke_config.subnet.ip_range_pods
      },
      {
        range_name    = var.gke_config.subnet.ip_range_svcs_name
        ip_cidr_range = var.gke_config.subnet.ip_range_svcs
      }
    ]
  })

  primary_subnets = concat([
    for fleet in var.fleets : {
      subnet_name   = fleet.subnet.name
      subnet_ip     = cidrsubnet(fleet.subnet.cidr, 2, 2)
      subnet_region = fleet.region
    }
    ], [
    {
      subnet_name   = var.gke_config.subnet.name
      subnet_ip     = var.gke_config.subnet.ip_range
      subnet_region = var.gke_config.region
    }
  ])

  flattened_primary_subnets = concat([
    for item in local.primary_subnets: item.subnet_ip
  ])

  flattened_secondary_subnets = concat([
    for item in flatten([for fleet in var.fleets: local.secondary_subnets[fleet.subnet.name]]): item.ip_cidr_range
  ])

}


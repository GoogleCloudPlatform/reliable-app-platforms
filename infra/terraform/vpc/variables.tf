variable "project_id" {
  description = "Project ID"
}

variable "network_name" {
  description = "VPC name"
  default = "vpc"
}

variable "fleets" {
  description = "List of networking configurations per cluster-group"
  type = list(object({
    region       = string
    env          = string
    num_clusters = number
    subnet = object({
      name = string
      cidr = string
    })
  }))
  default = [
    {
      region       = "us-west2"
      env          = "prod"
      num_clusters = 3
      subnet = {
        name = "us-west2"
        cidr = "10.1.0.0/17"
      }
    },
    {
      region       = "us-central1"
      env          = "prod"
      num_clusters = 3
      subnet = {
        name = "us-central1"
        cidr = "10.2.0.0/17"
      }
    },
  ]
}

variable "gke_config" {
  description = "Networking configuration for the config cluster in the anthos fleet"
  type = object({
    name    = string
    region  = string
    zone    = string
    env     = string
    network = string
    subnet = object({
      name               = string
      ip_range           = string
      ip_range_pods_name = string
      ip_range_pods      = string
      ip_range_svcs_name = string
      ip_range_svcs      = string
    })
  })
  default = {
    name    = "gke-config"
    region  = "us-central1"
    zone    = "us-central1-f" #TODO: This one is unused. 
    env     = "config" #TODO: This one is unused. 
    network = "vpc-prod" #TODO: This one is unused. 
    subnet = {
      name               = "us-central1-config"
      ip_range           = "10.10.0.0/20" 
      ip_range_pods_name = "us-central1-config-pods"
      ip_range_pods      = "10.11.0.0/18"
      ip_range_svcs_name = "us-central1-config-svcs"
      ip_range_svcs      = "10.12.0.0/24"
    }
  }
}

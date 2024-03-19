variable "project_id" {
  description = "Project ID"
}

variable "app_name" {
  description = "App name"
}

variable "service_name" {
  description = "Service name"
}

variable "pipeline_location" {
  description = "Pipeline location"
}

variable "archetype"{
  description = "Archetype to deploy service with. Accepted types are SZ (Single Zone), APZ (Active Passive Zone), MZ (Multi Zonal), APR (Active Passive Region), IR (Isolated Region) and G (Global)"
  type = string
  default = "SZ"
}

variable "region_index" {
  description = "Region index to deploy service to. Needs to be set for APR, IR"
  type = list(number) 
}

variable "zone_index" {
  description = "Zone index to deploy service to. Needs to be set for SZ, APZ, MZ"
  type = list(number)
}

# variable "project_id" {
#   description = "Project ID"
# }

variable "lb_name" {
  type = string
  description = "name prefix for generated loadbalancer objects"
}
variable "backends" {
  description = "backends for the load balancer. all fields are needed to identify a kubernetes service."
  type = map(object({
    service_obj = any
    # location = string
    # cluster = string
    # service_namespace = string
    # service_name = string
    # provider_alias = any
  }))
  default = {}
}
variable "project_id" {
  description = "Project ID"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use. Defaults to 1.27.3-gke.100"
  default = "1.27.3-gke.100"
}

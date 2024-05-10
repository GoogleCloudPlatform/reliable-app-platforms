variable "project_id" {
  description = "Project ID"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use. Defaults to 1.28.5-gke.1217000"
  default = "1.28.5-gke.1217000"
}

variable "allow_deletion" {
  description = "allow deletion of GKE clusters by terraform"
  default = true
  
}

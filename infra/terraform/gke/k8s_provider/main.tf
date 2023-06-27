# This is to circumvent a limitation that you cannot use loops in providers and we will need a seperate provider per cluster.
# Check here for more info on this limitation: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/673
# WIP: Might not need this yet.

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(var.ca_certificate)
}

module "asm" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
  project_id        = var.project_id
  cluster_name      = var.cluster_name
  cluster_location  = var.cluster_location
  enable_cni        = true 
}
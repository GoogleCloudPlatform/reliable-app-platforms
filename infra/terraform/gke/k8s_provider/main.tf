# This is to circumvent a limitation that you cannot use loops in providers and we will need a seperate provider per cluster.
# Check here for more info on this limitation: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/673
# WIP: Might not need this yet.

provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = var.access_token
  cluster_ca_certificate = base64decode(var.ca_certificate)
}
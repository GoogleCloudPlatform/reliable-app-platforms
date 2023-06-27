provider "kubernetes" {
  host                   = "https://${var.endpoint}"
  token                  = var.access_token
  cluster_ca_certificate = base64decode(var.ca_certificate)
}
# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "shop/payment/tfstate/slos"
  }
}
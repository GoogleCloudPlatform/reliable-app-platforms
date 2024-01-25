# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "shop/shop-frontend/tfstate/platform-infra"
  }
}
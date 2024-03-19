# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "shop/recommendations/tfstate/platform-infra"
  }
}
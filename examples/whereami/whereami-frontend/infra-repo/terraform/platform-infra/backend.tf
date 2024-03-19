# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "whereami/whereami-frontend/tfstate/platform-infra"
  }
}
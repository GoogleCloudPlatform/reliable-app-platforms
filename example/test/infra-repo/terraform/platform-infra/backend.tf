# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "whereami/test/tfstate/platform-infra"
  }
}
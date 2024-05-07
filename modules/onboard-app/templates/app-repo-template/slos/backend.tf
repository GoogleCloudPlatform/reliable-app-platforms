# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "APP_NAME/APP_NAME/tfstate/slos"
  }
}
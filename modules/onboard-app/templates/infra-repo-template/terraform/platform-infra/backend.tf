# terraform init -backend-config="bucket=${PROJECT_ID}"

terraform {
  backend "gcs" {
    prefix = "nginx/nginx/tfstate/platform-infra"
  }
}
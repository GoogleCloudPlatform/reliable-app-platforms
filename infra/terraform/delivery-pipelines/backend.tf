# terraform init -backend-config="bucket=${PROJECT_ID}" -backend-config="prefix=tfstate/pipeline/${SERVICE}"

terraform {
  backend "gcs" {
    prefix=tfstate/pipeline
  }
}
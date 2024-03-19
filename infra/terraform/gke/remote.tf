data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = var.project_id
    prefix = "tfstate/vpc"
  }
}
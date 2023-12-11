data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = var.project_id
    prefix = "tfstate/gke"
  }
}
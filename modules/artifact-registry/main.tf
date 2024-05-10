resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "${var.app_name}-${var.service_name}"
  description   = "docker repository for app ${var.app_name}, and service ${var.service_name}"
  format        = "DOCKER"
  project = var.project_id
  docker_config {
    immutable_tags = false
  }
}
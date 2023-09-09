locals {
    trigger_folders = distinct(flatten([
    for item in var.repo_config : [
      for folder in item.trigger_folders : {
        repo_name = item.repo_name
        folder_name    = folder
      }
    ]
  ]))
}

resource "google_sourcerepo_repository" "source-repo" {
  for_each = { for u in var.repo_config : u.repo_name => u }
  name = each.key
  project = var.project_id
}

resource "google_artifact_registry_repository" "artifact-repo" {
  for_each = toset(var.artifact_registry)
  project       = var.project_id
  location      = var.repo_location
  repository_id = each.value
  description   = "docker repository"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "trigger" {
  for_each = { for u in local.trigger_folders: "${u.repo_name}-${u.folder_name}" => u }
  name = "${each.key}-trigger"
  project = var.project_id
  location = var.repo_location

  trigger_template {
    branch_name = "main"
    repo_name   = each.value.repo_name
  }

  included_files = ["${each.value.folder_name}/**"]
  filename = "${each.value.folder_name}/ci.yaml"
}
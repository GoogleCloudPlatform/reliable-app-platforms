variable "app_name" {
  description = "Name of the application being created."
}

variable "github_repo" {
  description = "github repository as $owner/$repo_name"
}

variable "github_token" {
  description = "GitHub user access token."
  sensitive = true
  default = ""
}

variable "project_id" {
  description = "Project ID to use for Cloud Build execution"
}

variable "cloudbuild_file" {
  description = "relative path from repo root to a cloudbuild.yaml file to run on push to main"
  default = "cloudbuild.yaml"
}

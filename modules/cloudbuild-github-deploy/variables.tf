variable "app_name" {
  description = "Name of the application being created."
}

variable "github_repo" {
  description = "github repository as $owner/$repo_name"
}

# variable "github_org" {
#   description = "GitHub org."
# }

variable "github_user" {
  description = "GitHub username."
}

# variable "github_email" {
#   description = "GitHub user email."
# }

variable "github_token" {
  description = "GitHub user access token."
  sensitive = true
}

variable "project_id" {
  description = "Project ID to use for Cloud Build execution"
}
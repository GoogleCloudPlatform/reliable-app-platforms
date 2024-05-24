terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.27"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.27"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.2.1"
    }
  }
}

provider "github" {
  owner = local.repo_owner
  token = var.github_token
}
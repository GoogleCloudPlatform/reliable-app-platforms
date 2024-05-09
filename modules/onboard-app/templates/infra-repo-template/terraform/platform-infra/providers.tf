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
      source  = "hashicorp/github"
      version = ">= 4.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }

  }
}

provider "github" {
  owner = data.google_secret_manager_secret_version.github_org.secret_data
  token = data.google_secret_manager_secret_version.github_token.secret_data
}
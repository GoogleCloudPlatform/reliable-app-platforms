terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
    github = {
      source  = "hashicorp/github"
      version = ">= 4.3.0"
    }
  }
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}
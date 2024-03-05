terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.80.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.80.0"
    }
    github = {
      source  = "hashicorp/github"
      version = ">= 4.3.0"
    }
  }
}

provider "github" {
  organization = var.github_org
}
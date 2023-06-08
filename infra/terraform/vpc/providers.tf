terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.56.0"
    }
  }
}

provider "google-beta" {}

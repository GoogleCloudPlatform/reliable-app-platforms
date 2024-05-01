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
  }
}

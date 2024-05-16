terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.27"
    }
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
  }
}


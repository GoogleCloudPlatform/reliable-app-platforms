terraform {
  backend "gcs" {
    prefix = "//tfstate/platform-infra"
  }
}
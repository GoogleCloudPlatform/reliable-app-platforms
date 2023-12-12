resource "google_sourcerepo_repository" "acm-repo" {
  name = "config"
  project = var.project_id
}

resource "google_sourcerepo_repository" "gateway-repo" {
  name = "gateway"
  project = var.project_id
}


resource "google_compute_global_address" "global_loadbalancer_ip" {
    name = "mci"
    project = var.project_id
}

resource "google_endpoints_service" "whereami_endpoint" {
  project              = var.project_id
  service_name         = "whereami.endpoints.${var.project_id}.cloud.goog"
  openapi_config       = templatefile("./templates/endpoints.tftpl", {APP_NAME = "whereami", IP_ADDRESS = google_compute_global_address.global_loadbalancer_ip.address , PROJECT_ID = var.project_id})
}

resource "google_endpoints_service" "bankofanthos_endpoint" {
  project              = var.project_id
  service_name         = "bankofanthos.endpoints.${var.project_id}.cloud.goog"
  openapi_config       = templatefile("./templates/endpoints.tftpl", {APP_NAME = "bankofanthos", IP_ADDRESS = google_compute_global_address.global_loadbalancer_ip.address , PROJECT_ID = var.project_id})

}

resource "google_endpoints_service" "onlineshop_endpoint" {
  project              = var.project_id
  service_name         = "onlineshop.endpoints.${var.project_id}.cloud.goog"
  openapi_config       = templatefile("./templates/endpoints.tftpl", {APP_NAME = "onlineshop", IP_ADDRESS = google_compute_global_address.global_loadbalancer_ip.address , PROJECT_ID = var.project_id})
}
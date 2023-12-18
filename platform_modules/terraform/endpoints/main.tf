locals {
    gclb_ip_address = jsondecode(data.google_storage_bucket_object_content.gclb_info.content)
}

data "google_storage_bucket_object_content" "gclb_info" {
  name   = "platform-values/ip-address.json"
  bucket = var.project_id
}

resource "google_endpoints_service" "service-endpoint" {
  project              = var.project_id
  service_name         = "${var.service_name}.endpoints.${var.project_id}.cloud.goog"
  openapi_config       = templatefile("${path.module}/templates/endpoints.tftpl", {APP_NAME = "${var.service_name}", IP_ADDRESS = local.gclb_ip_address , PROJECT_ID = var.project_id})
}

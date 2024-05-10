output "apis" {
  value = google_endpoints_service.service-endpoint.apis
}

output "endpoints" {
  value = google_endpoints_service.service-endpoint.endpoints
}

output "ip" {
  value = local.gclb_ip_address 
}
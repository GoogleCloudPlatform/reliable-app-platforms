/**
 * # Module `http-loadbalancer-global`
 * 
 * This module creates a global loadbalancer, backed by a kubernetes service.
 * The service can be present in multiple clusters in any number of regions.
 *
 * The `backends.service_obj` items are `kubernetes_service` objects.
 * 
 * To use services from different kubernetes clusters, you will need to use
 * multiple kubernetes providers, using provider aliases.
 */

data "google_client_config" "default" {}

resource "terraform_data" "neg-helpers" {
  for_each = var.backends
  input = {
    svc_port = tostring(each.value.service_obj.spec.0.port.0.port)
    negnotes = jsondecode(each.value.service_obj.metadata[0].annotations["cloud.google.com/neg-status"])
    # negname = negnotes["network_endpoint_groups"][svc_port]
    negname = jsondecode(each.value.service_obj.metadata[0].annotations["cloud.google.com/neg-status"])["network_endpoint_groups"][tostring(each.value.service_obj.spec.0.port.0.port)]
    negzones = jsondecode(each.value.service_obj.metadata[0].annotations["cloud.google.com/neg-status"])["zones"]
  }
}

data "google_compute_network_endpoint_group" "backend_negs" {
  for_each = terraform_data.neg-helpers
  name = each.value.output.negname
  zone = each.value.output.negzones[0]
}

resource "google_compute_backend_service" "default" {
  name                  = var.lb_name
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.default.id]
  // for demonstration, use a random backend.
  locality_lb_policy = "RANDOM"
  // NEGS go here.
  // NOTE: zero is not a valid max_rate. must remove whole block to drain.
  dynamic "backend" {
    for_each = var.backends
    content {
      group = data.google_compute_network_endpoint_group.backend_negs[backend.key].id
      balancing_mode = "RATE"
      max_rate_per_endpoint = 100
    }
  }
}

// Health check, using the serving port on the kubernetes service object.
resource "google_compute_health_check" "default" {
  name = "${var.lb_name}-healthcheck"
  check_interval_sec = 3
  timeout_sec = 2
  healthy_threshold = 1
  http_health_check {
    port = 8080
  }
}

resource "google_compute_url_map" "default" {
  name            = "${var.lb_name}-urlmap"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.lb_name}-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.lb_name}-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
}

output "loadbalancer_url" {
  value = "http://${google_compute_global_forwarding_rule.default.ip_address}/"
}
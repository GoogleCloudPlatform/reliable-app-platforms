locals {
  slo_configs = [
    for file in fileset(path.module, "/templates/*.yaml") :
    yamldecode(templatefile(file,
      {
        project_id            = var.project_id,
        service_id            = google_monitoring_custom_service.primary.service_id,
        latency_threshold     = var.latency_threshold
        latency_goal = var.latency_goal
        latency_window = var.latency_window
        latency_rolling_period = var.latency_rolling_period
    }))
  ]
  slo_config_map = { for config in local.slo_configs : config.slo_id => config }
}

resource "google_monitoring_custom_service" "primary" {
  project      = var.project_id
  service_id   = "${var.service_name}-latency-slos"
  display_name = "${var.service_name}-latency-slos"
}

module "slo-uptime-latency500ms-window" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["latency-window"]
}
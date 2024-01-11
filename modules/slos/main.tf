locals {
  latency_config = yamldecode(templatefile("${path.module}/templates/latency.yaml",
  {
      project_id            = var.project_id,
        service_id            = google_monitoring_custom_service.primary.service_id,
        service_name = var.service_name
        latency_threshold     = var.latency_threshold
        latency_goal = var.latency_goal
        latency_window = var.latency_window
        latency_rolling_period = var.latency_rolling_period
  }))

    availability_config = yamldecode(templatefile("${path.module}/templates/availability.yaml",
  {
      project_id            = var.project_id,
        service_id            = google_monitoring_custom_service.primary.service_id,
        service_name = var.service_name
        availability_rolling_period = var.availability_rolling_period
        availability_goal = var.availability_goal
  }))
}

resource "google_monitoring_custom_service" "primary" {
  project      = var.project_id
  service_id   = "${var.service_name}-latency-slos"
  display_name = "${var.service_name}-latency-slos"
}

module "slo-latency" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.latency_config 
}


module "slo-availability" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.availability_config
}

resource "google_monitoring_alert_policy" "latency_alert_policy" {
  project = var.project_id
  display_name = "latency-alert"
  combiner     = "OR"
  conditions {
    display_name = " Burn rate for ${var.service_name} Latency with ${var.latency_alert_threshold} for ${var.latency_alert_lookback_duration}s lookback period"
    condition_threshold {
      filter     = "select_slo_burn_rate(${module.slo-latency.name},${var.latency_alert_lookback_duration}s)"
      duration   = "0s"
      comparison = "COMPARISON_GT"
    }
  }
}

resource "google_monitoring_alert_policy" "availability_alert_policy" {
  project = var.project_id
  display_name = "availability-alert"
  combiner     = "OR"
  conditions {
    display_name = " Burn rate for ${var.service_name} Availability for ${var.availability_alert_lookback_duration}s lookback period"
    condition_threshold {
      filter     = "select_slo_burn_rate(${module.slo-availability.name},${var.availability_alert_lookback_duration}s)"
      duration   = "0s"
      comparison = "COMPARISON_GT"
    }
  }
}
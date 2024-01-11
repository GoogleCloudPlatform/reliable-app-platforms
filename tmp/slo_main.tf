data "google_project" "project" {
  project_id = var.project_id
}

# Monitors the default MeshIstio service
data "google_monitoring_istio_canonical_service" "default" {
    project = var.project_id
    mesh_uid = "proj-${data.google_project.project.number}"
    canonical_service_namespace = "nginx" 
    canonical_service = "nginx"
}

module "slo_latency" {
  source = "terraform-google-modules/slo/google//modules/slo-native"
  config = {
    project_id        = var.project_id
    service           = data.google_monitoring_istio_canonical_service.default.service_id
    slo_id            = "${var.service_name}-latency-slo"
    display_name      = "Latency - ${var.latency_threshold}ms - ${var.latency_goal} - Calendar ${var.latency_period} Day"
    goal              = var.latency_goal
    calendar_period   = var.latency_period
    type              = "basic_sli"
    method            = "latency"
    latency_threshold = "${var.latency_threshold}s"
  }
}


resource "google_monitoring_alert_policy" "latency_alert_policy" {
  project = var.project_id
  display_name = "latency-alert"
  combiner     = "OR"
  conditions {
    display_name = " Burn rate for ${var.service_name} Latency with ${var.latency_alert_threshold} for ${var.latency_alert_lookback_duration}s lookback period"
    condition_threshold {
      filter     = "select_slo_burn_rate(${module.slo_latency.name},${var.latency_alert_lookback_duration}s)"
      duration   = "0s"
      comparison = "COMPARISON_GT"
    }
  }
}

module "slo_availability" {
  source = "terraform-google-modules/slo/google//modules/slo-native"
  config = {
    project_id        = var.project_id
    service           = data.google_monitoring_istio_canonical_service.default.service_id
    slo_id            = "${var.service_name}-availability-slo"
    display_name      = "Availability - ${var.availability_goal} - Calendar ${var.availability_period} Day"
    goal              = var.availability_goal
    calendar_period   = var.availability_period
    type              = "basic_sli"
    method            = "availability"
  }
}


resource "google_monitoring_alert_policy" "availability_alert_policy" {
  project = var.project_id
  display_name = "availability-alert"
  combiner     = "OR"
  conditions {
    display_name = " Burn rate for ${var.service_name} Availability with ${var.availability_alert_threshold} for ${var.availability_alert_lookback_duration}s lookback period"
    condition_threshold {
      filter     = "select_slo_burn_rate(${module.slo_availability.name},${var.availability_alert_lookback_duration}s)"
      duration   = "0s"
      comparison = "COMPARISON_GT"
    }
  }
}
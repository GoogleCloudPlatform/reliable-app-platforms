output "pipeline_id" {
  value = google_clouddeploy_delivery_pipeline.primary.id
}

output "targets" {
  value = local.targets #google_clouddeploy_target.target[*].id
}
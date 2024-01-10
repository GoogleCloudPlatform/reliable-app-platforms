output "pipeline_id" {
  value = google_clouddeploy_delivery_pipeline.primary.id
}

output "targets" {
  value = local.targets 
}

output "other_targets" {
  value = local.remaining_targets 
}


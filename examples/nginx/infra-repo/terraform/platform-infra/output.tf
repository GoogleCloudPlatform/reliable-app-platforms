output "deploy_targets" {
  value = module.deploy-pipeline.targets
}

output "pipeline_id" {
  value = module.deploy-pipeline.pipeline_id
}

output "endpoint" {
  value = module.endpoint.endpoints
}

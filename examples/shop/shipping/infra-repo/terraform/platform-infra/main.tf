module "artifact_registry"{
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/artifact-registry"
    project_id = var.project_id
    app_name = var.app_name
    service_name = var.service_name
}
module "deploy-pipeline"{
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/deploy-pipeline"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
    archetype = var.archetype
    zone_index = var.zone_index
    region_index = var.region_index
}
module "deploy-pipeline"{
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/deploy-pipeline"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
    archetype = var.archetype
    zone_index = var.zone_index
    region_index = var.region_index
}

module "endpoint" {
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.app_name}"
}

module "artifact_registry"{
    source = "../../../../../../../platform_modules/terraform/artifact-registry"
    project_id = var.project_id
    app_name = var.app_name
}

module "deploy-pipeline"{
    source = "../../../../../../../platform_modules/terraform/deploy-pipeline"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
    archetype = var.archetype
    zone_index = var.zone_index
    region_index = var.region_index
}

module "endpoint" {
    source = "../../../../../../../platform_modules/terraform/endpoints"
    project_id = var.project_id
    service_name = var.service_name
}
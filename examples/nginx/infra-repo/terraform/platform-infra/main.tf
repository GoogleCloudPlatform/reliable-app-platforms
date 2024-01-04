module "artifact_registry"{
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/artifact-registry?ref=tf_archetype_platform_modules"
    project_id = var.project_id
    app_name = var.app_name
}

module "deploy-pipeline"{
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/deploy-pipeline?ref=tf_archetype_platform_modules"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
    archetype = var.archetype
    zone_index = var.zone_index
    region_index = var.region_index
}

module "endpoint" {
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/endpoints?ref=tf_archetype_platform_modules"
    project_id = var.project_id
    service_name = "${var.service_name}1"
}
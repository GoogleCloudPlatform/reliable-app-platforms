# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

module "endpoint" {
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/endpoints"
    project_id = var.project_id
    service_name = "${var.service_name}service"
}
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

variable "project_id" {
  description = "Project ID"
}

variable "app_name" {
  description = "App name"
}

variable "service_name" {
  description = "Service name"
}

variable "pipeline_location" {
  description = "Pipeline location"
}

variable "archetype"{
  description = "Archetype to deploy service with. Accepted types are SZ (Single Zone), APZ (Active Passive Zone), MZ (Multi Zonal), APR (Active Passive Region), IR (Isolated Region) and G (Global)"
  type = string
  default = "SZ"
}

variable "region_index" {
  description = "Region index to deploy service to. Needs to be set for APR, IR"
  type = list(number) 
}

variable "zone_index" {
  description = "Zone index to deploy service to. Needs to be set for SZ, APZ, MZ"
  type = list(number)
}

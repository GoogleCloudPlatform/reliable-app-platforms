# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "app_name" {
  description = "Name of the application being created."
}

variable "github_repo" {
  description = "github repository as $owner/$repo_name"
}

variable "github_token" {
  description = "GitHub user access token."
  sensitive   = true
  default     = ""
}

variable "token_secret" {
  description = "secret manager secret to use instead of github_token"
  default     = ""
}

variable "project_id" {
  description = "Project ID to use for Cloud Build execution"
}

variable "cloudbuild_file" {
  description = "relative path from repo root to a cloudbuild.yaml file to run on push to main"
  default     = "cloudbuild.yaml"
}

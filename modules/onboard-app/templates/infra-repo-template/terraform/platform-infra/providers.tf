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

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.27"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
    github = {
      source  = "hashicorp/github"
      version = ">= 4.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

  }
}

provider "github" {
  owner = data.google_secret_manager_secret_version.github_org.secret_data
  token = data.google_secret_manager_secret_version.github_token.secret_data
}
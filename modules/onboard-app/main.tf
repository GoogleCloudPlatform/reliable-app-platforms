/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "google_project" "project" {
  project_id = var.project_id
}

locals{
  repo_name = split("/",github_repository.infra_repo.full_name)[1]
}

//Create infra repo
resource "github_repository" "infra_repo" {
  name        = "${var.app_name}-infra"
  description = "IaC repository for ${var.app_name}"

  visibility   = "private"
  has_issues   = false
  has_projects = false
  has_wiki     = false

  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  delete_branch_on_merge = false

  vulnerability_alerts = true
}

// perform placeholder replacements in the repo
resource "null_resource" "set_repo" {
  triggers = {
    id = github_repository.infra_repo.id
  }
  provisioner "local-exec" {
    command = "${path.cwd}/prep-infra-repo.sh ${var.app_name} ${var.github_org} ${var.github_user} ${var.github_email} ${var.github_token} ${local.repo_name}"
  }
  depends_on = [github_repository.infra_repo]
}

// create a webhook cloudbuild trigger
resource "random_password" "pass_webhook" {
  length  = 16
  special = false
}

resource "google_secret_manager_secret" "wh_sec" {
  project   = var.project_id
  secret_id = "${var.app_name}-infra-webhook-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "wh_secv" {
  secret      = google_secret_manager_secret.wh_sec.id
  secret_data = "${random_password.pass_webhook.result}"
}

data "google_iam_policy" "wh-secv-access" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = var.project_id
  secret_id   = google_secret_manager_secret.wh_sec.id
  policy_data = data.google_iam_policy.wh-secv-access.policy_data
}

resource "google_cloudbuild_trigger" "deploy_infra" {
  name        = "deploy-infra-${var.app_name}"
  description = "Webhook to deploy the infra"
  project     = var.project_id
  webhook_config {
    secret = google_secret_manager_secret_version.wh_secv.id
  }
  build {
    step {
      id         = "clone-infra-repo"
      name       = "gcr.io/cloud-builders/git"
      entrypoint = "sh"
      args = [
        "-c",
        <<-EOF
      git clone https://$$GITHUB_USER:$$GITHUB_TOKEN@github.com/$$GITHUB_ORG/${"$"}{_REPO}
      cd ${"$"}{_REPO}
  EOF
      ]
      secret_env = [
        "GITHUB_USER",
        "GITHUB_TOKEN",
        "GITHUB_ORG"]
    }
    step {
      name       = "hashicorp/terraform:1.4.6"
      id         = "create-app-infra"
      #dir        =  "terraform"
      entrypoint = "sh"
      args = [
        "-c",
        <<-EOF
      export TF_VAR_project_id=${"$"}{_PROJECT_ID}
      export TF_VAR_service_name=${"$"}{_SERVICE}
      export TF_VAR_app_name=${"$"}{_APP_NAME}
      export TF_VAR_archetype=${"$"}{_ARCHETYPE}
      export TF_VAR_zone_index=${"$"}{_ZONE_INDEX}
      export TF_VAR_region_index=${"$"}{_REGION_INDEX}
      export TF_VAR_pipeline_location=${"$"}{_PIPELINE_LOCATION}
      cd ${"$"}{_REPO}/terraform/platform-infra
      terraform init -backend-config="bucket=${"$"}{_PROJECT_ID}"
      terraform apply --auto-approve

  EOF
      ]

    }
    available_secrets {
      secret_manager {
        version_name = "projects/${var.project_id}/secrets/github-user/versions/latest"
        env = "GITHUB_USER"
      }
      secret_manager {
        version_name = "projects/${var.project_id}/secrets/github-token/versions/latest"
        env = "GITHUB_TOKEN"
      }
      secret_manager {
        version_name = "projects/${var.project_id}/secrets/github-org/versions/latest"
        env = "GITHUB_ORG"
      }
//      secret_manager {
//        version_name = "projects/${var.project_id}/secrets/github-email/versions/latest"
//        env = "GITHUB_EMAIL"
//      }

    }

  }
  substitutions = {
    _REPO       = local.repo_name
    _REF        = "${"$"}(body.ref)"
    _COMMIT_MSG = "${"$"}(body.head_commit.message)"
    _BUILD      = "true"
    _PROJECT_ID = var.project_id
    _APP_NAME   = var.app_name
    _SERVICE    = var.app_name
    _PIPELINE_LOCATION = "us-central1"
    _ARCHETYPE = "APZ"
    _ZONE_INDEX = "[0,1]"
    _REGION_INDEX = "[0,1]"
  }
  filter          = "(!_COMMIT_MSG.matches('IGNORE'))"
  depends_on      = [google_secret_manager_secret_version.wh_secv]


}

//TODO: remove timestamp from the name. It was added while doing the development to make rerunning possible
resource "google_apikeys_key" "api_key" {
  name         = "${var.app_name}-api-key"
  display_name = "${var.app_name} Infra webhook API"
  project      = var.project_id
  restrictions {
    api_targets {
      service = "cloudbuild.googleapis.com"
    }
  }
}

resource "github_repository_webhook" "gh_webhook" {
  provider   = github
  repository = local.repo_name
  configuration {
    url          = "https://cloudbuild.googleapis.com/v1/projects/${var.project_id}/triggers/deploy-infra-${var.app_name}:webhook?key=${google_apikeys_key.api_key.key_string}&secret=${random_password.pass_webhook.result}"
    content_type = "json"
    insecure_ssl = false
  }
  active     = true
  events     = ["push"]
  depends_on = [google_cloudbuild_trigger.deploy_infra]

}

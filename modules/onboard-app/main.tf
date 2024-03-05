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


//Create infra repo
resource "github_repository" "infra_repo" {
  name        = "${var.application_name}-infra"
  description = "Application code repository for ${var.application_name}"

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
resource "null_resource" "set-repo" {
  triggers = {
    id = github_repository.infra_repo.id
  }
  provisioner "local-exec" {
    command = "${path.module}/prep-app-repo.sh ${var.application_name} ${var.github_org} ${var.github_user} ${var.github_email} ${var.github_token} split('/',${github_repository.infra_repo.full_name})[1]"
  }
  depends_on = [github_repository.infra_repo]
}

// create a webhook cloudbuild trigger
resource "random_password" "pass-webhook" {
  length  = 16
  special = false
}

resource "google_secret_manager_secret" "wh-sec" {
  project   = var.project_id
  secret_id = "${var.application_name}-infra-webhook-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "wh-secv" {
  secret      = google_secret_manager_secret.wh-sec.id
  secret_data = "${random_password.pass-webhook.result}"
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
  secret_id   = google_secret_manager_secret.wh-sec.id
  policy_data = data.google_iam_policy.wh-secv-access.policy_data
}

resource "google_cloudbuild_trigger" "deploy-infra" {
  name        = "deploy-infra-${var.application_name}"
  description = "Webhook to deploy the infra"
  project     = var.project_id
  webhook_config {
    secret = google_secret_manager_secret_version.wh-secv.id
  }
  source_to_build {
    uri       = "https://github.com/${github_repository.infra_repo.full_name}"
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "create-infra.yaml"
    uri       = "https://github.com/${github_repository.infra_repo.full_name}"
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
  }

}


resource "google_apikeys_key" "api-key" {
  name         = "${var.application_name}-infra-webhook-api-key-1"
  display_name = "${var.application_name} Infra webhook API key-1"
  project      = var.project_id
  restrictions {
    api_targets {
      service = "cloudbuild.googleapis.com"
    }
  }
}

resource "github_repository_webhook" "gh-webhook" {
  provider   = github
  repository = "${var.application_name}-infra"
  configuration {
    url          = "https://cloudbuild.googleapis.com/v1/projects/${var.project_id}/triggers/deploy-infra-${var.application_name}:webhook?key=${google_apikeys_key.api-key.key_string}&secret=${random_password.pass-webhook.result}"
    content_type = "json"
    insecure_ssl = false
  }
  active     = true
  events     = ["push"]
  depends_on = [google_cloudbuild_trigger.deploy-infra]

}

/**
 * Module `cloudbuild-github-deploy`
 *
 * This module creates Cloud Build triggers to run when the provided github repo
 * is updated.
 *
 * It handles the complexity of connecting cloud build and github together.
 *
 */

/*
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
}

data "google_secret_manager_secret_version" "gh_access" {
  secret = var.token_secret
}

locals {
  repo_owner = split("/", var.github_repo)[0]
  repo_name  = split("/", var.github_repo)[1]
}

resource "google_project_service" "required_apis" {
  for_each = toset(["secretmanager", "apikeys"])
  service  = "${each.value}.googleapis.com"
}

resource "random_password" "pass_webhook" {
  length  = 16
  special = false
}

resource "google_secret_manager_secret" "gh_webhook" {
  secret_id = "${var.app_name}-github-webhook-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "wh_secv" {
  secret      = google_secret_manager_secret.gh_webhook.id
  secret_data = random_password.pass_webhook.result
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
  secret_id   = google_secret_manager_secret.gh_webhook.id
  policy_data = data.google_iam_policy.wh-secv-access.policy_data
}

resource "google_cloudbuild_trigger" "deploy" {
  name        = "deploy-${var.app_name}"
  description = "Webhook to deploy from ${var.github_repo}"
  project     = var.project_id
  webhook_config {
    secret = google_secret_manager_secret_version.wh_secv.id
  }
  source_to_build {
    uri       = "https://github.com/${var.github_repo}"
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }
  filename = "cloudbuild/build-deploy.yaml"

  substitutions = {
    # TODO: plumb this through to the $PROJECT_ID env var at build time.
    _PROJECT_ID = data.google_project.project.project_id
    _APP_NAME   = var.app_name
  }
  # filter          = "(!_COMMIT_MSG.matches('IGNORE'))"
  depends_on = [google_secret_manager_secret_version.wh_secv]


}

resource "google_apikeys_key" "api_key" {
  name         = "${var.app_name}-gh-cloudbuild"
  display_name = "${var.app_name} webhook for github calling cloudbuild"
  project      = var.project_id
  restrictions {
    api_targets {
      service = "cloudbuild.googleapis.com"
    }
  }
  depends_on = [google_project_service.required_apis]
}

resource "github_repository_webhook" "gh_webhook" {
  provider   = github
  repository = local.repo_name
  configuration {
    url          = "https://cloudbuild.googleapis.com/v1/projects/${var.project_id}/triggers/${google_cloudbuild_trigger.deploy.name}:webhook?key=${google_apikeys_key.api_key.key_string}&secret=${random_password.pass_webhook.result}"
    content_type = "json"
    insecure_ssl = false
    secret       = random_password.pass_webhook.result
  }
  active     = true
  events     = ["push"]
  depends_on = [google_cloudbuild_trigger.deploy]

}

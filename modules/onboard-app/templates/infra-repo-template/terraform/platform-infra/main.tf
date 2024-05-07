data "google_project" "project" {
    project_id = var.project_id
}

data "google_secret_manager_secret_version" "github_user" {
    secret = "github-user"
    project = var.project_id
}

data "google_secret_manager_secret_version" "github_email" {
    secret = "github-email"
    project = var.project_id
}

data "google_secret_manager_secret_version" "github_token" {
    secret = "github-token"
    project = var.project_id
}

data "google_secret_manager_secret_version" "github_org" {
    secret = "github-org"
    project = var.project_id
}
locals{
    repo_name = split("/",github_repository.app_repo.full_name)[1]
    github_user = data.google_secret_manager_secret_version.github_user.secret_data
    github_email = data.google_secret_manager_secret_version.github_email.secret_data
    github_org = data.google_secret_manager_secret_version.github_org.secret_data
    github_token = data.google_secret_manager_secret_version.github_token.secret_data
}

//resource "random_string" "random" {
//    length           = 8
//    special          = false
//}

module "artifact_registry"{
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/artifact-registry?ref=cloud-maniac-temp-tf"
    project_id = var.project_id
    app_name = var.app_name
    service_name = var.service_name
}

module "deploy-pipeline"{
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/deploy-pipeline?ref=cloud-maniac-temp-tf"
    project_id = var.project_id
    service_name = var.service_name
    pipeline_location = var.pipeline_location
    archetype = var.archetype
    zone_index = var.zone_index
    region_index = var.region_index
}

module "endpoint" {
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/endpoints?ref=cloud-maniac-temp-tf"
    project_id = var.project_id
    service_name = "${var.service_name}service"
}

// Create a application source code repo and a Cloudbuild webhook trigger attached to it.
resource "github_repository" "app_repo" {
    name        = "${var.app_name}"
    description = "Application code repository for ${var.app_name}"

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
        id = github_repository.app_repo.id
    }
    provisioner "local-exec" {
        command = "${path.cwd}/../../scripts/prep-app-repo.sh ${var.app_name} ${local.github_org} ${local.github_user} ${local.github_email} ${local.github_token} ${local.repo_name} ${var.project_id}"
    }
    depends_on = [github_repository.app_repo]
}

// create a webhook cloudbuild trigger
resource "random_password" "pass_webhook" {
    length  = 16
    special = false
}

resource "google_secret_manager_secret" "wh_sec" {
    project   = var.project_id
    secret_id = "${var.app_name}-app-webhook-secret"
    replication {
        automatic = true
    }
}

resource "google_secret_manager_secret_version" "wh_secv" {
    secret      = google_secret_manager_secret.wh_sec.id
    secret_data = "${random_password.pass_webhook.result}"
}

data "google_iam_policy" "wh_secv_access" {
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
    policy_data = data.google_iam_policy.wh_secv_access.policy_data
}

resource "google_cloudbuild_trigger" "deploy_app" {
    name        = "deploy-app-${var.app_name}"
    description = "Webhook to deploy the application"
    project     = var.project_id
    webhook_config {
        secret = google_secret_manager_secret_version.wh_secv.id
    }
    build {
        step {
            id         = "clone-app-repo"
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
            name       = "gcr.io/cloud-builders/gcloud"
            id         = "deploy-to-app-clusters"
            #dir        =  "terraform"
            entrypoint = "bash"
            args = [
                "-c",
                <<-EOF
      echo -e "_PROJECT_ID is ${"$"}{_PROJECT_ID}"
      echo -e "_PIPELINE_LOCATION is ${"$"}{_REGION}"
      echo -e "_APP_NAME is ${"$"}{_APP_NAME}"
      echo -e "_SERVICE is ${"$"}{_SERVICE}"
      cd ${"$"}{_REPO}
      gcloud deploy releases create "rel-$(date '+%Y%m%d%H%M%S')" --delivery-pipeline ${"$"}{_SERVICE}-pipeline --region ${"$"}{_REGION} --skaffold-file=./skaffold_workload_clusters.yaml

  EOF
            ]

        }
        step {
            name       = "gcr.io/cloud-builders/gcloud"
            id         = "deploy-to-other-clusters"
            #dir        =  "terraform"
            entrypoint = "bash"
            args = [
                "-c",
                <<-EOF
      echo -e "_PROJECT_ID is ${"$"}{_PROJECT_ID}"
      echo -e "_PIPELINE_LOCATION is ${"$"}{_REGION}"
      echo -e "_APP_NAME is ${"$"}{_APP_NAME}"
      echo -e "_SERVICE is ${"$"}{_SERVICE}"
      cd ${"$"}{_REPO}
      gcloud deploy releases create "rel-$(date '+%Y%m%d%H%M%S')" --delivery-pipeline ${"$"}{_SERVICE}-vs-pipeline --region ${"$"}{_REGION} --skaffold-file=./skaffold_other_clusters.yaml


  EOF
            ]
        }
    step {
      name       = "hashicorp/terraform:1.4.6"
      id         = "create-slos"
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
      cd ${"$"}{_REPO}/slos
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
        #_PIPELINE_LOCATION = "us-central1"
        #_ARCHETYPE = "APZ"
        #_ZONE_INDEX = "[0,1]"
        #_REGION_INDEX = "[0,1]"
        _REGION = "us-central1"
        #_SHORT_SHA = random_string.random.result
    }
    filter          = "(!_COMMIT_MSG.matches('IGNORE'))"
    depends_on      = [google_secret_manager_secret_version.wh_secv]


}

//TODO: remove timestamp from the name. It was added while doing the development to make rerunning possible
resource "google_apikeys_key" "api_key" {
    name         = "${var.app_name}-app-api-key"
    display_name = "${var.app_name} App webhook API"
    project      = var.project_id
    restrictions {
        api_targets {
            service = "cloudbuild.googleapis.com"
        }
    }
}

resource "github_repository_webhook" "gh-webhook" {
    provider   = github
    repository = local.repo_name
    configuration {
        url          = "https://cloudbuild.googleapis.com/v1/projects/${var.project_id}/triggers/deploy-app-${var.app_name}:webhook?key=${google_apikeys_key.api_key.key_string}&secret=${random_password.pass_webhook.result}"
        content_type = "json"
        insecure_ssl = false
    }
    active     = true
    events     = ["push"]
    depends_on = [google_cloudbuild_trigger.deploy_app]

}

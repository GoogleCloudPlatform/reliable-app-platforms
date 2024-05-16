# Onboard App - HOWTO

Onboard-app is how we adopt existing codebases into RAP.

This is a gitops CI/CD system that uses:

- GitHub
  - You need an Org to store your repos for each team or service (see below)
- Cloud Build for CI
- Cloud Deploy for CD

You will want to structure your app in the following manner:

1. app repo
1. infra repo

So, for an app named "myapp" you'll have:  "myapp" and "myapp-infra"

## onboard.sh

this script sets some variables and secrets, then calls `cloudbuild.yaml` on Cloud Build

it currently has app names hardcoded.

## cloudbuild.yaml

this sets up a terraform run with the appropriate values in place.

## onboard-app/main.tf

1. this creates the "app-infra" repository in your GitHub Org
1. it runs `prep-infra-repo.sh` - populating the "app-infra" repo appropriately, if it doesn't exist
1. it then creates a webhook in GitHub to notify Cloud Build about changes to that repo
1. it then creates a trigger in Cloud Build which does:
  1. clones the "app-infra" repo
  1. runs `terraform/platform-infra` from that repo

## onboard-app/infra-repo-template/terraform/platform-infra/main.tf

This becomes a part of the `app-infra` repo in your Org.  There its path is just `terraform/platform-infra/main.tf`.

This runs:

1. pulls down tf modules from RAP: `artifact_registry`, `deploy_pipeline`, and `endpoints`.
1. it runs `prep-app-repo.sh` - populating the "app" repo appropriately, if it doesn't exist
1. it pulls down the latest "app" repo
1. it then creates a webhook in GitHub to notify Cloud Build about changes to that repo
1. it then creates a trigger in Cloud Build which:
    1. creates and runs two Cloud Deploy releases:
        1. deploy-to-app-clusters
        1. deploy-to-other-clusters
    1. it then sets up SLOs (still WIP) as pulled from `modules/slos`


# Module Details

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.27 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.3.0 |
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.27 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Resources

| Name | Type |
|------|------|
| [github_repository.infra_repo](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository) | resource |
| [github_repository_webhook.gh_webhook](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_webhook) | resource |
| [google_apikeys_key.api_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) | resource |
| [google_cloudbuild_trigger.deploy_infra](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_secret_manager_secret.wh_sec](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_policy) | resource |
| [google_secret_manager_secret_version.wh_secv](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [null_resource.set_repo](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.pass_webhook](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_iam_policy.wh-secv-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application being created. | `any` | n/a | yes |
| <a name="input_github_email"></a> [github\_email](#input\_github\_email) | GitHub user email. | `any` | n/a | yes |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | GitHub org. | `any` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub user email. | `any` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | GitHub username. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

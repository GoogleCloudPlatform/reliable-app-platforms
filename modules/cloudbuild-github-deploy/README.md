# Deployment Hooks Module

This module creates Continuous Deployment hooks for a Github Repository, that
will build and deploy using Google Cloud Build.

If you wish to use Github's fine-grained access tokens (recommended), the token
will need read-only access to the Content category, and read-write access to
the Webhook category.

If you wish to restrict access to specific repositories, but the organization
does not appear in the dropdown, ask your github org admin to enable personal
access tokens for your organization.

# Module Details

<!-- BEGIN_TF_DOCS -->
Copyright 2024 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 6.2.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.27 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.2.1 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.30.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.gh_webhook](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [google_apikeys_key.api_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/apikeys_key) | resource |
| [google_cloudbuild_trigger.deploy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [google_secret_manager_secret.gh_webhook](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.github_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.github_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_policy) | resource |
| [google_secret_manager_secret_version.github_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.github_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.wh_secv](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [random_password.pass_webhook](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_iam_policy.wh-secv-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application being created. | `any` | n/a | yes |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | github repository as $owner/$repo\_name | `any` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub user access token. | `any` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | GitHub username. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID to use for Cloud Build execution | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

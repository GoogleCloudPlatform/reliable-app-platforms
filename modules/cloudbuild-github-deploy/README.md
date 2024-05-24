# Deployment Hooks Module

This module creates Continuous Deployment hooks for a Github Repository, that
will build and deploy using Google Cloud Build.

If you wish to use Github's fine-grained access tokens (recommended), the token
will need read-only access to the Content category, and read-write access to
the Webhook category.

If you wish to restrict access to specific repositories, but the organization
does not appear in the dropdown, ask your github org admin to enable personal
access tokens for your organization.

In order for the included `google_cloudbuild_trigger` to work, you will need to
[connect your github
repository](https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github),
which may require installing the [Google Cloud Build Github
App](https://github.com/marketplace/google-cloud-build).

# Module Details

<!-- BEGIN_TF_DOCS -->
Module `cloudbuild-github-deploy`

This module creates Cloud Build triggers to run when the provided github repo
is updated.

It handles the complexity of connecting cloud build and github together.

TODO: enable secretmanager api.

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
| [google_secret_manager_secret_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_policy) | resource |
| [google_secret_manager_secret_version.wh_secv](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [random_password.pass_webhook](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_iam_policy.wh-secv-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application being created. | `any` | n/a | yes |
| <a name="input_cloudbuild_file"></a> [cloudbuild\_file](#input\_cloudbuild\_file) | relative path from repo root to a cloudbuild.yaml file to run on push to main | `string` | `"cloudbuild.yaml"` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | github repository as $owner/$repo\_name | `any` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | GitHub user access token. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID to use for Cloud Build execution | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Module `artifact-registry`

This module creates an [artifact
registry](https://cloud.google.com/artifact-registry) repository suitable for
hosting docker containers built by our platform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.27 |

## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.repo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name. Defaults to unknown | `string` | `"unknown"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `any` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service name. Defaults to unknown | `string` | `"unknown"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

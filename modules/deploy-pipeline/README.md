# Module `deploy-pipeline`

This module creates a Cloud Deploy pipeline to enable continuous delivery in the
context of Reliable App Platform.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.27 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.27 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 5.27 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_clouddeploy_delivery_pipeline.primary](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_clouddeploy_delivery_pipeline) | resource |
| [google-beta_google_clouddeploy_delivery_pipeline.secondary](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_clouddeploy_delivery_pipeline) | resource |
| [google_clouddeploy_target.child_target_apps](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/clouddeploy_target) | resource |
| [google_clouddeploy_target.child_target_vs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/clouddeploy_target) | resource |
| [google_clouddeploy_target.multi_target_apps](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/clouddeploy_target) | resource |
| [google_clouddeploy_target.multi_target_vs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/clouddeploy_target) | resource |
| [google_project_iam_member.clouddeploy_container_developer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.clouddeploy_member_deploy_jobrunner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.clouddeploy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket_object_content.clusters_info](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archetype"></a> [archetype](#input\_archetype) | Archetype to deploy service with. Accepted types are SZ (Single Zone), APZ (Active Passive Zone), MZ (Multi Zonal), APR (Active Passive Region), IR (Isolated Region) and G (Global) | `string` | `"SZ"` | no |
| <a name="input_pipeline_location"></a> [pipeline\_location](#input\_pipeline\_location) | Pipeline location. | `string` | `"us-central1"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `any` | n/a | yes |
| <a name="input_region_index"></a> [region\_index](#input\_region\_index) | Region index to deploy service to. Needs to be set for MZ, APR, IR | `list(number)` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the service | `string` | `"unnamed"` | no |
| <a name="input_zone_index"></a> [zone\_index](#input\_zone\_index) | Zone index to deploy service to. Needs to be set for SZ, APZ | `list(number)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_other_targets"></a> [other\_targets](#output\_other\_targets) | n/a |
| <a name="output_pipeline_id"></a> [pipeline\_id](#output\_pipeline\_id) | n/a |
| <a name="output_target"></a> [target](#output\_target) | n/a |
| <a name="output_targets"></a> [targets](#output\_targets) | n/a |
<!-- END_TF_DOCS -->

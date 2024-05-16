# Module `endpoints`

This module creates [cloud endpoints](https://cloud.google.com/endpoints), used
to create serving hostnames for applications deployed through the Reliable App
Platform.

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
| [google_endpoints_service.service-endpoint](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/endpoints_service) | resource |
| [google_storage_bucket_object_content.gclb_info](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `any` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service name | `string` | `"Unnamed"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apis"></a> [apis](#output\_apis) | n/a |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | n/a |
| <a name="output_ip"></a> [ip](#output\_ip) | n/a |
<!-- END_TF_DOCS -->

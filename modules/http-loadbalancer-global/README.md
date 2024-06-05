<!-- BEGIN_TF_DOCS -->
This module creates a global loadbalancer, backed by a kubernetes service.
The service can be present in multiple clusters in any number of regions.

The `backends.service_obj` items are `kubernetes_service` objects.

To use services from different kubernetes clusters, you will need to use
multiple kubernetes providers, using provider aliases.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.27 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_forwarding_rule.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_health_check.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| terraform_data.neg-helpers | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_network_endpoint_group.backend_negs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network_endpoint_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backends"></a> [backends](#input\_backends) | backends for the load balancer. Service\_obj is a kubernetes\_service terraform object. | <pre>map(object({<br>    service_obj = any<br>  }))</pre> | `{}` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | name prefix for generated loadbalancer objects | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backends"></a> [backends](#output\_backends) | n/a |
| <a name="output_loadbalancer_url"></a> [loadbalancer\_url](#output\_loadbalancer\_url) | n/a |
<!-- END_TF_DOCS -->
# Module `slos`

This module creates SLO resources for applications deployed with the Reliable
App Platform.

Note that the application must be deployed before SLOs can be created, as SLO
creation depends on Service objects created in Cloud Monitoring. See [issue #29
](https://github.com/GoogleCloudPlatform/reliable-app-platforms/issues/29) for
more details

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
| [google_monitoring_alert_policy.availability_alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.latency_alert_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_istio_canonical_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/monitoring_istio_canonical_service) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_alert_lookback_duration"></a> [availability\_alert\_lookback\_duration](#input\_availability\_alert\_lookback\_duration) | in s. Defaults to 300 | `number` | `300` | no |
| <a name="input_availability_alert_threshold"></a> [availability\_alert\_threshold](#input\_availability\_alert\_threshold) | value | `number` | `10` | no |
| <a name="input_availability_calendar_period"></a> [availability\_calendar\_period](#input\_availability\_calendar\_period) | Defaults to DAY | `string` | `"DAY"` | no |
| <a name="input_availability_goal"></a> [availability\_goal](#input\_availability\_goal) | Availability target goal. Defaults to 0.999 | `number` | `0.999` | no |
| <a name="input_availability_rolling_period"></a> [availability\_rolling\_period](#input\_availability\_rolling\_period) | Availability rolling period in days. Defaults to 1 | `number` | `1` | no |
| <a name="input_latency_alert_lookback_duration"></a> [latency\_alert\_lookback\_duration](#input\_latency\_alert\_lookback\_duration) | in s. Defaults to 300 | `number` | `300` | no |
| <a name="input_latency_alert_threshold"></a> [latency\_alert\_threshold](#input\_latency\_alert\_threshold) | value | `number` | `10` | no |
| <a name="input_latency_calendar_period"></a> [latency\_calendar\_period](#input\_latency\_calendar\_period) | Defaults to DAY | `string` | `"DAY"` | no |
| <a name="input_latency_goal"></a> [latency\_goal](#input\_latency\_goal) | Latency target goal. Defaults to 0.9 | `number` | `0.9` | no |
| <a name="input_latency_rolling_period"></a> [latency\_rolling\_period](#input\_latency\_rolling\_period) | Latency rolling period in days. Defaults to 1 | `number` | `1` | no |
| <a name="input_latency_threshold"></a> [latency\_threshold](#input\_latency\_threshold) | Latency rolling threshold in ms. Defaults to 500 | `number` | `500` | no |
| <a name="input_latency_window"></a> [latency\_window](#input\_latency\_window) | Latency window period in s. Defaults to 400 | `number` | `400` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID | `any` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Service name | `string` | `"unnamed"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

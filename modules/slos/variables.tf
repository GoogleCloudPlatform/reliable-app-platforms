variable "project_id" {
  description = "Project ID"
}

variable "service_name" {
  description = "Service name"
  default = "unnamed"
}

variable "latency_goal" {
  description = "Latency target goal. Defaults to 0.9"
  default = 0.9
} 

variable "latency_window" {
  description = "Latency window period in s. Defaults to 400"
  default = 400
} 

variable "latency_rolling_period" {
  description = "Latency rolling period in days. Defaults to 1"
  default = 1
} 


variable "latency_threshold" {
  description = "Latency rolling threshold in ms. Defaults to 500"
  default = 500
} 
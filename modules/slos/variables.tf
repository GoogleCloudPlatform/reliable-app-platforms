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

variable "latency_alert_threshold" {
  description = "value"
  default = 10
}

variable "latency_calendar_period" {
  description = "Defaults to DAY"
  default = "DAY"
}

variable "latency_alert_lookback_duration" {
  description = "in s. Defaults to 300"
  default = 300
}

variable "availability_goal" {
  description = "Availability target goal. Defaults to 0.999"
  default = 0.999
} 

variable "availability_rolling_period" {
  description = "Availability rolling period in days. Defaults to 1"
  default = 1
} 


variable "availability_alert_threshold" {
  description = "value"
  default = 10
}

variable "availability_alert_lookback_duration" {
  description = "in s. Defaults to 300"
  default = 300
}

variable "availability_calendar_period" {
  description = "Defaults to DAY"
  default = "DAY"
}
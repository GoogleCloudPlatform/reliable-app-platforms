module "slos" {
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/slos?ref=tf"
    project_id = var.project_id
    service_name = "${var.service_name}"
    availability_goal = "0.999"
    latency_goal = "0.9"
}
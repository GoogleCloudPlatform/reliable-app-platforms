module "slos" {
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/slos"
    project_id = var.project_id
    service_name = "${var.service_name}"
    availability_goal = "0.999"
    latency_goal = "0.9"
}
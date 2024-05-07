module "slos" {
    source = "git::https://github.com/GoogleCloudPlatform/reliable-app-platforms.git//modules/slos?ref=cloud-maniac-temp-tf"
    project_id = var.project_id
    service_name = "${var.service_name}service"
}
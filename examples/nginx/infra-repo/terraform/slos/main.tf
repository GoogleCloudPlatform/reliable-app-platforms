module "slos" {
    source = "git::https://github.com/ameer00/Building-Reliable-Platforms-on-GCP-with-Google-SRE.git//modules/slos?ref=tf_in_repo_examples"
    project_id = var.project_id
    service_name = "${var.service_name}service"
}
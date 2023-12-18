resource "google_compute_global_address" "global_loadbalancer_ip" {
    name = "mcg"
    project = var.project_id
}

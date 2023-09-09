# created in the cloud endpoints module
data "google_compute_global_address" "mci_address" {
  name = "mci"
  project = var.project_id
}

resource "google_storage_bucket_object" "vars" {
  name   = "vars.sh"
  content = templatefile("vars.tftpl", local.substitutions)
  bucket = var.project_id
}


locals {
  clusters_info = data.terraform_remote_state.gke.outputs.fleet-clusters
  }

resource "google_clouddeploy_target" "target" {
  for_each = {for i, v in local.clusters_info: i => v}
  location = each.value.region
  name     = "target-${each.value.name}"

  gke {
    cluster = each.value.id
  }

  project          = var.project_id
  require_approval = false
}
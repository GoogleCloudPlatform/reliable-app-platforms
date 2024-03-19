
# # #TODO: MCS always exists error

# # resource "google_gke_hub_feature" "mcs_feature" {
# #   name     = "multiclusterservicediscovery"
# #   location = "global"
# #   project  = var.project_id
# # }

# resource "google_gke_hub_feature_membership" "mcs_feature_member" {
#   for_each   = module.fleet-hub
#   location   = each.value.location
#   feature    = "multiclusterservicediscovery" #google_gke_hub_feature.mcs_feature.name
#   membership = each.value.cluster_membership_id
#   project    = var.project_id
# }


# resource "google_gke_hub_feature_membership" "mcs_config_feature_member" {
#   location   = module.config-hub.location
#   feature    = "multiclusterservicediscovery" #google_gke_hub_feature.mcs_feature.name
#   membership = module.config-hub.cluster_membership_id
#   project    = var.project_id
# }

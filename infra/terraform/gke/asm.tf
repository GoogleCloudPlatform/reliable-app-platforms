# locals {
#     hub-membership-feature = concat([
#         for membership in google_gke_hub_membership.fleet-membership: {
#             google_gke_hub_feature.asm-feature.membership.name = membership.membership_id
#         }
#     ])
# }
# resource "google_gke_hub_feature" "asm-feature" {
#   for_each = google_gke_hub_membership.fleet-membership
#   name = "servicemesh-${each.value.name}"
#   location = "global" # Should this be global?
#   provider = google-beta
# }

# resource "google_gke_hub_feature_membership" "feature_member" {
#   for_each = google_gke_hub_membership.fleet-membership
#   location = "global"
#   feature = each.key
#   membership = each.value
#   mesh {
#     management = "MANAGEMENT_AUTOMATIC"
#   }
#   provider = google-beta
# }
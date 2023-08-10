module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
#   version = 
  project_id                  = var.project_id
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "mesh.googleapis.com",
    "multiclusteringress.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "trafficdirector.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "servicemanagement.googleapis.com",
    "artifactregistry.googleapis.com",
    "sourcerepo.googleapis.com",
    "anthos.googleapis.com",
    "gkehub.googleapis.com",
    "clouddeploy.googleapis.com",
    "spanner.googleapis.com",
    "sqladmin.googleapis.com",
    "containersecurity.googleapis.com",
    "binaryauthorization.googleapis.com",
    "anthosconfigmanagement.googleapis.com"
  ]
}
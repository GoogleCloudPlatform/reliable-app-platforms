variable "project_id" {
  description = "Project ID"
}

variable "repo_location" {
  description = "Location for artifact registry repository"
  type = string
  default = "us-central1"
}

variable "artifact_registry"{
  description = "Artifact registry repos to create"
  type = list(string)
  default = [ "bank", "shop", "whereami" ]

}
variable "repo_config" {
  description = "Combination of repos and build triggers to create"
   type = list(object({
    repo_name       = string
    trigger_folders = list(string)
  }))
  default = [
    {
      repo_name = "bank"
      trigger_folders = ["accounts-db", "balancereader", "contacts", "frontend", "ledger-db", "ledgerwriter", "loadgenerator", "transactionhistory", "user"]
    },
    {
      repo_name = "shop"
      trigger_folders = [ "ad", "cart", "checkout", "currency", "email", "frontend", "loadgenerator", "payment", "productcatalog", "recommendation", "redis", "spanner", "shipping" ]
    },
    {
      repo_name = "whereami"
      trigger_folders = [ "whereami-backend", "whereami-frontend" ]
    },
    {
      repo_name = "config"
      trigger_folders = []
    },
    {
      repo_name = "ops"
      trigger_folders = [ "asm" ]
    }
  ]
}
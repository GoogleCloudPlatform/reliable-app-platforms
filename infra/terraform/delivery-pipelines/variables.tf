variable "project_id" {
  description = "Project ID"
}

variable "service_names" {
  type        = list(string)
  description = "list of service names"
  default     = ["whereami-frontend", "whereami-backend", "shop-ad", "shop-cart", "shop-checkout", "shop-currency", "shop-email", "shop-frontend", "shop-loadgenerator", "shop-payment", "shop-productcatalog", "shop-recommendation", "shop-shipping", "shop-redis", "bank-accounts-db", "bank-balancereader", "bank-contacts", "bank-frontend", "bank-ledger-db", "bank-ledgerwriter", "bank-loadgenerator", "bank-transactionhistory", "bank-user"]
}

variable "pipeline_location" {
  description = "Pipeline location."
  type        = string
  default     = "us-central1"
}
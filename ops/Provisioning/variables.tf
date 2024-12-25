variable "location" {
  default = "East US"
  description = "Azure region for resources"
}

variable "node_count" {
  default     = 2
  description = "Number of nodes in the AKS cluster"
}
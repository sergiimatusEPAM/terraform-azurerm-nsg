# Cluster Name
variable "name_prefix" {
  description = "Cluster Name"
}

# Format the hostname inputs are index+1, region, name_prefix
variable "hostname_format" {
  description = "Format the hostname inputs are index+1, region, cluster_name"
  default = "nsg-%[1]d-%[2]s"
}

# Name of the azure resource group
variable "resource_group_name" {
  description = "resource group name"
}

# Specify dcos role for nsg configuration
variable "dcos_role" {
  description = "dcos role"
}

# Location (region)
variable "location" {
  description = "location"
}

# Add special tags to the resources created by this module
variable "tags" {
  description = "Add custom tags to all resources"
  type    = "map"
  default = {}
}

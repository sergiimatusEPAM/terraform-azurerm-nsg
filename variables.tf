# Cluster Name
variable "cluster_name" {
  description = "Cluster Name"
}

# Format the hostname inputs are index+1, region, name_prefix
variable "hostname_format" {
  description = "Format the hostname inputs are index+1, region, cluster_name"
  default     = "nsg-%[1]d-%[2]s"
}

# Name of the azure resource group
variable "resource_group_name" {
  description = "resource group name"
}

# Location (region)
variable "location" {
  description = "location"
}

# Add special tags to the resources created by this module
variable "tags" {
  description = "Add custom tags to all resources"
  type        = "map"
  default     = {}
}

variable "admin_ips" {
  description = "List of CIDR admin IPs"
  type        = "list"
}

variable "public_agents_ips" {
  description = "List of ips allowed access to public agents. admin_ips are joined to this list"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "public_agents_additional_ports" {
  description = "List of additional ports allowed for public access on public agents (80 and 443 open by default)"
  type        = "list"
  default     = []
}

variable "subnet_range" {
  description = "Private IP space to be used in CIDR format"
}

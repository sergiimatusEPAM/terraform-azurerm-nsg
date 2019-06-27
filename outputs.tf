output "bootstrap.nsg_name" {
  description = "Network security group name of the bootstrap"
  value       = "${azurerm_network_security_group.bootstrap.name}"
}

output "bootstrap.nsg_id" {
  description = "Network security group id of the bootstrap"
  value       = "${azurerm_network_security_group.bootstrap.id}"
}

output "masters.nsg_name" {
  description = "Network security group name of the masters"
  value       = "${azurerm_network_security_group.masters.name}"
}

output "masters.nsg_id" {
  description = "Network security group id of the masters"
  value       = "${azurerm_network_security_group.masters.id}"
}

output "private_agents.nsg_name" {
  description = "Network security group name of the private agents"
  value       = "${azurerm_network_security_group.private_agents.name}"
}

output "private_agents.nsg_id" {
  description = "Network security group id of the private agents"
  value       = "${azurerm_network_security_group.private_agents.id}"
}

output "public_agents.nsg_name" {
  description = "Network security group name of the public agents"
  value       = "${azurerm_network_security_group.public_agents.name}"
}

output "public_agents.nsg_id" {
  description = "Network security group id of the public agents"
  value       = "${azurerm_network_security_group.public_agents.id}"
}

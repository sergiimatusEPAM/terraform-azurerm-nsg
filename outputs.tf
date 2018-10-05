# Network Security Group Name
output "bootstrap.nsg_name" {
  description = "nsg name"

  value = "${azurerm_network_security_group.bootstrap.name}"
}

# Network Security Group ID
output "bootstrap.nsg_id" {
  description = "nsg id"

  value = "${azurerm_network_security_group.bootstrap.id}"
}

output "masters.nsg_name" {
  description = "nsg name"

  value = "${azurerm_network_security_group.masters.name}"
}

# Network Security Group ID
output "masters.nsg_id" {
  description = "nsg id"

  value = "${azurerm_network_security_group.masters.id}"
}

output "private_agents.nsg_name" {
  description = "nsg name"

  value = "${azurerm_network_security_group.private_agents.name}"
}

# Network Security Group ID
output "private_agents.nsg_id" {
  description = "nsg id"

  value = "${azurerm_network_security_group.private_agents.id}"
}

output "public_agents.nsg_name" {
  description = "nsg name"

  value = "${azurerm_network_security_group.public_agents.name}"
}

# Network Security Group ID
output "public_agents.nsg_id" {
  description = "nsg id"

  value = "${azurerm_network_security_group.public_agents.id}"
}

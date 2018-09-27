# Network Security Group Name
output "nsg_name" {
  description = "nsg name"

  value = "${element(concat(azurerm_network_security_group.bootstrap.*.name,
                            azurerm_network_security_group.master.*.name,
                            azurerm_network_security_group.agent.*.name,
                            azurerm_network_security_group.public_agent.*.name,
                            azurerm_network_security_group.vnet_public_subnet.*.name,
                            list("")), 0)}"
}

# Network Security Group ID
output "nsg_id" {
  description = "nsg id"

  value = "${element(concat(azurerm_network_security_group.bootstrap.*.id,
                            azurerm_network_security_group.master.*.id,
                            azurerm_network_security_group.agent.*.id,
                            azurerm_network_security_group.public_agent.*.id,
                            azurerm_network_security_group.vnet_public_subnet.*.id,
                            list("")), 0)}"
}

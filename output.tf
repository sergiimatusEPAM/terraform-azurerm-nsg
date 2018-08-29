output "nsg_name" {
  value = "${element(concat(azurerm_network_security_group.bootstrap.*.name,
                            azurerm_network_security_group.master.*.name,
                            azurerm_network_security_group.agent.*.name,
                            azurerm_network_security_group.public_agent.*.name,
                            list("")), 0)}"
}

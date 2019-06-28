output "bootstrap.nsg_name" {
  description = "Network security group name of the bootstrap"
  value       = "${element(concat(azurerm_network_security_group.bootstrap.*.name,list("")),0)}"
}

output "bootstrap.nsg_id" {
  description = "Network security group id of the bootstrap"
  value       = "${element(concat(azurerm_network_security_group.bootstrap.*.id,list("")),0)}"
}

output "masters.nsg_name" {
  description = "Network security group name of the masters"
  value       = "${element(concat(azurerm_network_security_group.masters.*.name,list("")),0)}"
}

output "masters.nsg_id" {
  description = "Network security group id of the masters"
  value       = "${element(concat(azurerm_network_security_group.masters.*.id,list("")),0)}"
}

output "private_agents.nsg_name" {
  description = "Network security group name of the private agents"
  value       = "${element(concat(azurerm_network_security_group.private_agents.*.name,list("")),0)}"
}

output "private_agents.nsg_id" {
  description = "Network security group id of the private agents"
  value       = "${element(concat(azurerm_network_security_group.private_agents.*.id,list("")),0)}"
}

output "public_agents.nsg_name" {
  description = "Network security group name of the public agents"
  value       = "${element(concat(azurerm_network_security_group.public_agents.*.name,list("")),0)}"
}

output "public_agents.nsg_id" {
  description = "Network security group id of the public agents"
  value       = "${element(concat(azurerm_network_security_group.public_agents.*.id,list("")),0)}"
}

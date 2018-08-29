# Agent Security Groups for NICs
resource "azurerm_network_security_group" "agent_security_group" {
  count               = "${dcos_role == "agent" ? 1 : 0 }"
  name                = "${data.template_file.cluster-name.rendered}-agent-security-group"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.dcos.name}"

  tags {
    Name       = "${coalesce(var.owner, data.external.whoami.result["owner"])}"
    expiration = "${var.expiration}"
  }
}

resource "azurerm_network_security_rule" "agent-sshRule" {
  count                       = "${dcos_role == "agent" ? 1 : 0 }"
  name                        = "sshRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.agent_security_group.name}"
}

resource "azurerm_network_security_rule" "agent-internalEverything" {
  count                       = "${dcos_role == "agent" ? 1 : 0 }"
  name                        = "allOtherInternalTraffric"
  priority                    = 160
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.agent_security_group.name}"
}

resource "azurerm_network_security_rule" "agent-everythingElseOutBound" {
  count                       = "${dcos_role == "agent" ? 1 : 0 }"
  name                        = "allOtherTrafficOutboundRule"
  priority                    = 170
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.agent_security_group.name}"
}

# End of Agent NIC Security Group


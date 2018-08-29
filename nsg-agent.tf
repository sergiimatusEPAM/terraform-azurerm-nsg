# Agent Security Groups for NICs
resource "azurerm_network_security_group" "agent" {
  count               = "${var.dcos_role == "agent" ? 1 : 0 }"
  name                = "${format(var.hostname_format, count.index + 1, var.name_prefix)}-agent-security-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.name_prefix),
                                "Cluster", var.name_prefix))}"
}

resource "azurerm_network_security_rule" "agent-sshRule" {
  count                       = "${var.dcos_role == "agent" ? 1 : 0 }"
  name                        = "sshRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.agent.name}"
}

resource "azurerm_network_security_rule" "agent-internalEverything" {
  count                       = "${var.dcos_role == "agent" ? 1 : 0 }"
  name                        = "allOtherInternalTraffric"
  priority                    = 160
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.agent.name}"
}

resource "azurerm_network_security_rule" "agent-everythingElseOutBound" {
  count                       = "${var.dcos_role == "agent" ? 1 : 0 }"
  name                        = "allOtherTrafficOutboundRule"
  priority                    = 170
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.agent.name}"
}

# End of Agent NIC Security Group


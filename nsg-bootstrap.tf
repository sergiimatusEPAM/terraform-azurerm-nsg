# Bootstrap Security Groups for NICs
resource "azurerm_network_security_group" "bootstrap_security_group" {
  count               = "${dcos_role == "bootstrap" ? 1 : 0 }"
  name                = "${data.template_file.cluster-name.rendered}-bootstrap-security-group"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.dcos.name}"

  tags {
    Name       = "${coalesce(var.owner, data.external.whoami.result["owner"])}"
    expiration = "${var.expiration}"
  }
}

resource "azurerm_network_security_rule" "bootstrap-sshRule" {
  count                       = "${dcos_role == "bootstrap" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.bootstrap_security_group.name}"
}

resource "azurerm_network_security_rule" "bootstrap-httpRule" {
  count                       = "${dcos_role == "bootstrap" ? 1 : 0 }"
  name                        = "HTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.bootstrap_security_group.name}"
}

resource "azurerm_network_security_rule" "bootstrap-httpsRule" {
  count                       = "${dcos_role == "bootstrap" ? 1 : 0 }"
  name                        = "HTTPS"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.bootstrap_security_group.name}"
}

resource "azurerm_network_security_rule" "bootstrap-internalEverything" {
  count                       = "${dcos_role == "bootstrap" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.bootstrap_security_group.name}"
}

resource "azurerm_network_security_rule" "bootstrap-everythingElseOutBound" {
  count                       = "${dcos_role == "bootstrap" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.bootstrap_security_group.name}"
}

# End of Bootstrap NIC Security Group


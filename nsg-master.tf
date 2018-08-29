# Master Security Groups for NICs
resource "azurerm_network_security_group" "master_security_group" {
  count               = "${dcos_role == "master" ? 1 : 0 }"
  name                = "${data.template_file.cluster-name.rendered}-master-security-group"
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.dcos.name}"

  tags {
    Name       = "${coalesce(var.owner, data.external.whoami.result["owner"])}"
    expiration = "${var.expiration}"
  }
}

resource "azurerm_network_security_rule" "master-sshRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-httpRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-httpsRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-ZooKeeperRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
  name                        = "ZooKeeper"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "2181"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-ExhibitorRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
  name                        = "Exhibitor"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8181"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-MarathonRule" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
  name                        = "Marathon"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.dcos.name}"
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-internalEverything" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

resource "azurerm_network_security_rule" "master-everythingElseOutBound" {
  count                       = "${dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master_security_group.name}"
}

# End of Master NIC Security Group


# Master Security Groups for NICs
resource "azurerm_network_security_group" "master" {
  count               = "${var.dcos_role == "master" ? 1 : 0 }"
  name                = "${format(var.hostname_format, count.index + 1, var.name_prefix)}-master-security-group"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.name_prefix),
                                "Cluster", var.name_prefix))}"
}

resource "azurerm_network_security_rule" "master-sshRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-httpRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
  name                        = "HTTP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-httpsRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
  name                        = "HTTPS"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-ZooKeeperRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
  name                        = "ZooKeeper"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "2181"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-ExhibitorRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
  name                        = "Exhibitor"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8181"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-MarathonRule" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
  name                        = "Marathon"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-internalEverything" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

resource "azurerm_network_security_rule" "master-everythingElseOutBound" {
  count                       = "${var.dcos_role == "master" ? 1 : 0 }"
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
  network_security_group_name = "${azurerm_network_security_group.master.name}"
}

# End of Master NIC Security Group


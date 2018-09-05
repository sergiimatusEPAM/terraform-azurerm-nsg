# Public Subnet Security Groups
resource "azurerm_network_security_group" "vnet_public_subnet" {
    count = "${var.dcos_role == "vnet" ? 1 : 0 }"
    name = "${format(var.hostname_format, count.index + 1, var.name_prefix)}-vnet-security-group"
    location = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.name_prefix),
                                "Cluster", var.name_prefix))}"
}

# Public Subnet NSG Rule
resource "azurerm_network_security_rule" "public-subnet-httpRule" {
    count = "${var.dcos_role == "vnet" ? 1 : 0 }"
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
    network_security_group_name = "${azurerm_network_security_group.vnet_public_subnet.name}"
}

# Public Subnet NSG Rule
resource "azurerm_network_security_rule" "public-subnet-httpsRule" {
    count = "${var.dcos_role == "vnet" ? 1 : 0 }"
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
    network_security_group_name = "${azurerm_network_security_group.vnet_public_subnet.name}"
}

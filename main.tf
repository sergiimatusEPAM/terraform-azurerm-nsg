/**
 * [![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/buildStatus/icon?job=dcos-terraform%2Fterraform-azurerm-nsg%2Fsupport%252F0.2.x)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-nsg/job/support%252F0.2.x/)
 *
 * azurerm nsg
 * ===========
 * The module creates DC/OS Network Security Groups per DC/OS role on AzureRM.
 *
 * EXAMPLE
 * -------
 *
 * ```hcl
 * module "dcos-security-groups" {
 *   source  = "dcos-terraform/nsg/azurerm"
 *   version = "~> 0.2.0"
 *
 *   resource_group_name = "test"
 *   location            = "West US"
 *   subnet_range        = ["10.0.10.0/24"]
 *   admin_ips           = ["1.2.3.4/32"]
 * }
 * ```
 */

provider "azurerm" {}

locals {
  public_agents_additional_ports = "${concat(list("80","443"),var.public_agents_additional_ports)}"
}

resource "azurerm_network_security_group" "masters" {
  count               = "${var.num_masters == 0 ? 0 : 1}"
  name                = "dcos-${var.cluster_name}-masters"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "sshRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                         = "allowAllInternal"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = ["${var.subnet_range}"]
    destination_address_prefixes = ["${var.subnet_range}"]
  }

  security_rule {
    name                       = "allowAllOut"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "httpRule"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    destination_address_prefix = "*"
    source_address_prefixes    = ["${var.admin_ips}"]
  }

  security_rule {
    name                       = "httpsRule"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    destination_address_prefix = "*"
    source_address_prefixes    = ["${var.admin_ips}"]
  }

  security_rule {
    name                       = "8080Rule"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8181"
    destination_address_prefix = "*"
    source_address_prefixes    = ["${var.admin_ips}"]
  }

  security_rule {
    name                       = "9090Rule"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    destination_address_prefix = "*"
    source_address_prefixes    = ["${var.admin_ips}"]
  }

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.cluster_name),
                                "Cluster", var.cluster_name))}"
}

resource "azurerm_network_security_group" "public_agents" {
  count               = "${var.num_public_agents == 0 ? 0 : 1}"
  name                = "dcos-${var.cluster_name}-public-agents"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "sshRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                         = "allowAllInternal"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = ["${var.subnet_range}"]
    destination_address_prefixes = ["${var.subnet_range}"]
  }

  security_rule {
    name                       = "allowAllOut"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowHTTPadmin"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = ["${var.admin_ips}"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowHTTPSadmin"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["${var.admin_ips}"]
    destination_address_prefix = "*"
  }

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.cluster_name),
                                "Cluster", var.cluster_name))}"
}

resource "azurerm_network_security_rule" "additional_rules" {
  count                       = "${var.num_public_agents == 0 ? 0 : length(local.public_agents_additional_ports)}"
  name                        = "publicagentadditional${count.index}"
  priority                    = "${150 + count.index}"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${element(local.public_agents_additional_ports, count.index)}"
  source_address_prefixes     = ["${var.public_agents_ips}"]
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.public_agents.name}"
  depends_on                  = ["azurerm_network_security_group.public_agents"]
}

resource "azurerm_network_security_group" "private_agents" {
  count               = "${var.num_private_agents == 0 ? 0 : 1}"
  name                = "dcos-${var.cluster_name}-private-agents"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "sshRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                         = "allowAllInternal"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = ["${var.subnet_range}"]
    destination_address_prefixes = ["${var.subnet_range}"]
  }
  
  security_rule {
    name                       = "allowWinRM"
    description                = "Allow WinRM calls"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "allowWinRM"
    description                = "Allow WinRM calls"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowRDP"
    description                = "Allow RDP access"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowAllOut"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.cluster_name),
                                "Cluster", var.cluster_name))}"
}

resource "azurerm_network_security_group" "bootstrap" {
  count               = "${var.num_bootstrap == 0 ? 0 : 1}"
  name                = "dcos-${var.cluster_name}-bootstrap"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "sshRule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                         = "allowAllInternal"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefixes      = ["${var.subnet_range}"]
    destination_address_prefixes = ["${var.subnet_range}"]
  }

  security_rule {
    name                       = "allowAllOut"
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.cluster_name),
                                "Cluster", var.cluster_name))}"
}


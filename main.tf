/**
 * [![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-nsg/job/master/badge/icon)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-nsg/job/master/)
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
 *   version = "~> 0.1"
 *
 *   resource_group_name = "test"
 *   location            = "West US"
 *   subnet_range        = "10.0.10.0/24"
 *   admin_ips           = ["1.2.3.4/32"]
 * }
 * ```
 */

provider "azurerm" {}

resource "azurerm_network_security_group" "masters" {
  name                = "dcos-${var.cluster_name}-masters-firewall"
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
    destination_address_prefixes = ["${var.admin_ips}"]
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
    name                         = "httpRule"
    priority                     = 110
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "80"
    source_address_prefix        = "*"
    destination_address_prefixes = ["${var.admin_ips}"]
  }

  security_rule {
    name                         = "httpsRule"
    priority                     = 111
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["${var.admin_ips}"]
  }

  security_rule {
    name                         = "8080Rule"
    priority                     = 150
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "8181"
    source_address_prefix        = "*"
    destination_address_prefixes = ["${var.admin_ips}"]
  }

  security_rule {
    name                         = "9090Rule"
    priority                     = 160
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "9090"
    source_address_prefix        = "*"
    destination_address_prefixes = ["${var.admin_ips}"]
  }

  tags = "${merge(var.tags, map("Name", format(var.hostname_format, (count.index + 1), var.location, var.cluster_name),
                                "Cluster", var.cluster_name))}"
}

resource "azurerm_network_security_group" "public_agents" {
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
    destination_address_prefixes = ["${var.admin_ips}"]
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
    name                       = "allowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["${var.public_agents_ips}"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowHTTPS"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["${var.public_agents_ips}"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowHTTPadmin"
    priority                   = 112
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["${var.admin_ips}"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowHTTPSadmin"
    priority                   = 113
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

resource "azurerm_network_security_group" "private_agents" {
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
    destination_address_prefixes = ["${var.admin_ips}"]
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
    destination_address_prefixes = ["${var.admin_ips}"]
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

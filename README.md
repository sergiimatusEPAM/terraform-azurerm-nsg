[![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/buildStatus/icon?job=dcos-terraform%2Fterraform-azurerm-nsg%2Fsupport%252F0.1.x)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/SKELETON/job/support%252F0.1.x/)

Azure DC/OS nsg
===========
The module creates DC/OS Network Security Groups per DC/OS role on Azure.

EXAMPLE
-------

```hcl
module "dcos-security-groups" {
  source  = "dcos-terraform/nsg/azurerm"
  version = "~> 0.1.0"

  resource_group_name = "test"
  location            = "West US"
  subnet_range        = "10.0.10.0/24"
  admin_ips           = ["1.2.3.4/32"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_ips | List of CIDR admin IPs | list | n/a | yes |
| cluster\_name | Name of the DC/OS cluster | string | n/a | yes |
| location | Azure Region | string | n/a | yes |
| resource\_group\_name | Name of the azure resource group | string | n/a | yes |
| subnet\_range | Private IP space to be used in CIDR format | string | n/a | yes |
| hostname\_format | Format the hostname inputs are index+1, region, cluster_name | string | `"nsg-%[1]d-%[2]s"` | no |
| public\_agents\_additional\_ports | List of additional ports allowed for public access on public agents (80 and 443 open by default) | list | `<list>` | no |
| public\_agents\_ips | List of ips allowed access to public agents. admin_ips are joined to this list | list | `<list>` | no |
| tags | Add custom tags to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| bootstrap.nsg\_id | nsg id |
| bootstrap.nsg\_name | nsg name |
| masters.nsg\_id | nsg id |
| masters.nsg\_name | nsg name |
| private\_agents.nsg\_id | nsg id |
| private\_agents.nsg\_name | nsg name |
| public\_agents.nsg\_id | nsg id |
| public\_agents.nsg\_name | nsg name |


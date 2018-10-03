[![Build Status](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-nsg/job/master/badge/icon)](https://jenkins-terraform.mesosphere.com/service/dcos-terraform-jenkins/job/dcos-terraform/job/terraform-azurerm-nsg/job/master/)
# azurerm nsg
The module creates DC/OS Network Security Groups per DC/OS role on AzureRM.


## EXAMPLE

```hcl
module "dcos-security-groups" {
  source  = "dcos-terraform/nsg/azurerm"
  version = "~> 0.1"

  dcos_role = "master"
  resource_group_name = "test"
  location = "West US"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dcos_role | dcos role | string | - | yes |
| hostname_format | Format the hostname inputs are index+1, region, cluster_name | string | `nsg-%[1]d-%[2]s` | no |
| location | location | string | - | yes |
| name_prefix | Cluster Name | string | - | yes |
| resource_group_name | resource group name | string | - | yes |
| tags | Add custom tags to all resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| nsg_id | Network Security Group ID |
| nsg_name | Network Security Group Name |


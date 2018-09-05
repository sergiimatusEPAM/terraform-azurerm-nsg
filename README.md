# azurerm nsg 
The module creates DC/OS Network Security Groups per DC/OS role on AzureRM.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dcos_role | Specify dcos role for nsg configuration | string | - | yes |
| hostname_format | Format the hostname inputs are index+1, region, name_prefix | string | `nsg-%[1]d-%[2]s` | no |
| location | Location (region) | string | - | yes |
| name_prefix | Cluster Name | string | - | yes |
| resource_group_name | Name of the azure resource group | string | - | yes |
| tags | Add special tags to the resources created by this module | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| nsg_name |  |

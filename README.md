## Terraform & Packer demo - AWS

Welcome to the Terraform & Packer demo repository.

This repository serves as a sample Terraform and Packer configuration to automate the building of machine OS images and provision cloud resources accross AWS and GCP cloud providers.

## Usage

### Terraform

**Initial setup**

 1. Login in Terraform Cloud
 2. Create an organization to structure your workspaces and projects layout according to your needs.
 3. Setup two workspaces: One workspace destined to AWS resources, one for GCP resources.
 4. Create a variable set for AWS and insert AWS execution variables according to your access level and privileges in your AWS account.
 5. Create a variable set for GCP and insert GCP execution variables according to your access level and privileges in your GCP account.

**Execution**

 1. Export AWS credentials as environment variables or inside your credentials file at `$HOME/.aws/` folder
 2. Authenticate in your GCP account via your CLI, get the path of your json credentials file, and export the `GOOGLE_APPLICATION_CREDENTIALS` with this file credentials.
 3. Run `terraform init` to set up your working environment with the correct providers
 4. Create a `terraform.tfvars` from the empty `terraform.tfvars.clear` file with the corresponding values of each cloud provider.
 4. Run `terraform fmt` and `terraform validate` to update your hcl files format and check for syntax and validation errors.
 6. Run `terraform plan` and `terraform apply`. Review the execution plan to understand if the resources to be deployed match your configuration.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.40.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | ~> 0.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.40.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | ~> 0.82.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | terraform-aws-modules/ec2-instance/aws | 5.6.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.public_ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_key_pair.ssh_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group_rule.sg_inbound_flask](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_inbound_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_inbound_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_outbound_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.sg_outbound_https_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.auto_private_subnet_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.auto_public_subnet_cidrs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_iam_policy_document.ssm_management](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [hcp_packer_artifact.aws_ubuntu_acme_frontend_img](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_artifact) | data source |
| [hcp_packer_version.ubuntu_acme_frontend](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name to deploy resources in. This must be set on a per environment level. | `string` | `"us-west-2"` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list(string)` | <pre>[<br>  "us-west-2a"<br>]</pre> | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR block to associate with the VPC | `string` | `"10.100.0.0/16"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Object defining tagging strategy to use through the entire codebase. You must set this on a per environment level. | <pre>object({<br>    owner       = string<br>    environment = string<br>    version     = number<br>  })</pre> | <pre>{<br>  "environment": "lab",<br>  "owner": "ACME",<br>  "version": 0<br>}</pre> | no |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable\_dhcp\_options set to true) | `list(string)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the Default VPC | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | n/a | yes |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | `bool` | n/a | yes |
| <a name="input_hcp_bucket_acme_images"></a> [hcp\_bucket\_acme\_images](#input\_hcp\_bucket\_acme\_images) | HCP Packer bucket name for base ubuntu image | `string` | `"base-ubuntu-amd64-img"` | no |
| <a name="input_hcp_channel"></a> [hcp\_channel](#input\_hcp\_channel) | HCP Packer channel name | `string` | `"development"` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Object defining tagging strategy to use with ec2 instances. You must set this on a per environment level. | <pre>object({<br>    tier = string<br>    type = string<br>  })</pre> | <pre>{<br>  "tier": "frontend",<br>  "type": "web"<br>}</pre> | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`. | `bool` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of azs | `list(string)` | <pre>[<br>  "10.100.15.0/24"<br>]</pre> | no |
| <a name="input_propagate_private_route_tables_vgw"></a> [propagate\_private\_route\_tables\_vgw](#input\_propagate\_private\_route\_tables\_vgw) | Should be true if you want route table propagation | `bool` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of azs | `list(string)` | <pre>[<br>  "10.100.10.0/24"<br>]</pre> | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Admin SSH public key | `string` | n/a | yes |
| <a name="input_subnet_tags"></a> [subnet\_tags](#input\_subnet\_tags) | subnet specific tags | `map(any)` | <pre>{<br>  "size": 256<br>}</pre> | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | VPC specific tags | `map(any)` | <pre>{<br>  "network": "aws_prod"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_acme_frontend"></a> [aws\_acme\_frontend](#output\_aws\_acme\_frontend) | output "ubuntu\_acme\_frontend" { value = data.hcp\_packer\_version.ubuntu\_acme\_frontend }  output "aws\_ubuntu\_acme\_frontend\_img" { value = data.hcp\_packer\_artifact.aws\_ubuntu\_acme\_frontend\_img } |
<!-- END_TF_DOCS -->
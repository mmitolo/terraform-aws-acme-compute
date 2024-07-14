variable "aws_region" {
  type        = string
  description = "AWS Region name to deploy resources in. This must be set on a per environment level."
  default     = "us-west-2"
}

variable "default_tags" {
  type = object({
    owner       = string
    environment = string
    version     = number
  })
  description = "Object defining tagging strategy to use through the entire codebase. You must set this on a per environment level."
  default = {
    owner       = "ACME"
    environment = "lab"
    version     = 0
  }
}

variable "instance_tags" {
  type = object({
    tier = string
    type = string
  })
  description = "Object defining tagging strategy to use with ec2 instances. You must set this on a per environment level."
  default = {
    tier = "frontend"
    type = "web"
  }
}

variable "ssh_public_key" {
  type        = string
  description = "Admin SSH public key"
}

variable "cidr" {
  type        = string
  description = "CIDR block to associate with the VPC"
  default     = "10.100.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of azs"
  default     = ["10.100.10.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "define only if the subnet cannot be autocalculated or if the number of subnets needed is different from the number of azs"
  default     = ["10.100.15.0/24"]
}

variable "vpc_tags" {
  type        = map(any)
  description = "VPC specific tags"
  default = {
    network = "aws_prod"
  }
}

variable "subnet_tags" {
  type        = map(any)
  description = "subnet specific tags"
  default = {
    size = 256
  }
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones in the region"
  default     = ["us-west-2a"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
}

variable "propagate_private_route_tables_vgw" {
  type        = bool
  description = "Should be true if you want route table propagation"
}

variable "enable_vpn_gateway" {
  type        = bool
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"

}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Should be true to enable DNS hostnames in the Default VPC"
  default     = true
}

variable "enable_dhcp_options" {
  type        = bool
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  default     = true
}

variable "dhcp_options_domain_name_servers" {
  type        = list(string)
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  default     = ["AmazonProvidedDNS"]
}

variable "hcp_bucket_acme_images" {
  type        = string
  description = "HCP Packer bucket name for hashicups image"
  default     = "acme-corp-image-mgmt"
}

variable "hcp_channel" {
  type        = string
  description = "HCP Packer channel name"
  default     = "development"
}
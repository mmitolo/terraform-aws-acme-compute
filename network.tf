module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name = "${var.default_tags.owner}-vpc"
  cidr = var.cidr
  azs  = var.azs

  private_subnets       = local.private_subnet_cidrs
  private_subnet_suffix = "prv-subnet"
  public_subnets        = local.public_subnet_cidrs
  public_subnet_suffix  = "pub-subnet"

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dhcp_options              = var.enable_dhcp_options
  dhcp_options_domain_name_servers = var.dhcp_options_domain_name_servers

  vpc_tags            = var.vpc_tags
  private_subnet_tags = var.subnet_tags
  public_subnet_tags  = var.subnet_tags
}

resource "aws_security_group_rule" "sg_inbound_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "sg_inbound_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "sg_inbound_flask" {
  type              = "ingress"
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc.default_security_group_id
}

# improvement https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html
resource "aws_security_group_rule" "sg_outbound_https_ssm" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "sg_outbound_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpc.default_security_group_id
}
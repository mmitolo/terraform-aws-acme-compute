data "aws_iam_policy_document" "ssm_management" {
  statement {
    sid = "ssm"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:SendCommand",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "ssmmessages"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "ec2messages"
    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_key_pair" "ssh_public_key" {
  key_name   = "admin-public-key"
  public_key = var.ssh_public_key
}

resource "aws_iam_policy" "public_ssm_policy" {
  name        = "test_policy"
  path        = "/"
  description = "ec2 IAM policy"
  policy      = data.aws_iam_policy_document.ssm_management.json
}

locals {
  public_instances = {
    frontend = {
      instance_type     = "t3.micro"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.public_subnets, 0)
      private_ip        = cidrhost(element(module.vpc.public_subnets_cidr_blocks, 0), 9)
    }
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  for_each = local.public_instances

  name = "${var.default_tags.owner}-${each.key}"

  ami                         = data.hcp_packer_artifact.aws_ubuntu_acme_frontend_img.external_identifier
  instance_type               = each.value.instance_type
  availability_zone           = each.value.availability_zone
  subnet_id                   = each.value.subnet_id
  private_ip                  = each.value.private_ip
  key_name                    = aws_key_pair.ssh_public_key.id
  associate_public_ip_address = true
  enable_volume_tags          = false

  create_iam_instance_profile = true
  iam_role_name               = "${var.default_tags.owner}-${each.key}-iam-role"
  iam_role_description        = "${var.default_tags.owner} ${each.key} IAM role"
  iam_role_path               = "/ec2/"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    AmazonSSMManagement          = aws_iam_policy.public_ssm_policy.arn
  }

  tags = var.instance_tags
}
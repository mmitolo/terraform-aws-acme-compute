terraform {
  cloud {
    organization = "acme-corp-tfc"

    workspaces {
      name = "acme-corp-tfc-aws"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.82.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.default_tags
  }
}

provider "hcp" {}
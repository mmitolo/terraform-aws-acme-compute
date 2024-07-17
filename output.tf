output "ubuntu_acme_frontend" {
  value = data.hcp_packer_version.ubuntu_acme_frontend
}

output "aws_ubuntu_acme_frontend_img" {
  value = data.hcp_packer_artifact.aws_ubuntu_acme_frontend_img
}

output "aws_acme_frontend_public_ip" {
  value = module.ec2["frontend"].public_ip
}

output "aws_acme_frontend_public_dns" {
  value = module.ec2["frontend"].public_dns
}
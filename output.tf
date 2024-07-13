#output "ubuntu_acme_frontend" {
#  value = data.hcp_packer_version.ubuntu_acme_frontend
#}
#
#output "aws_ubuntu_acme_frontend_img" {
#  value = data.hcp_packer_artifact.aws_ubuntu_acme_frontend_img
#}
#
output "aws_acme_frontend" {
  value = [
    module.ec2["frontend"].id,
  module.ec2["frontend"].public_ip]
}
data "hcp_packer_version" "ubuntu_acme_frontend" {
  bucket_name  = var.hcp_bucket_acme_images
  channel_name = var.hcp_channel
}

data "hcp_packer_artifact" "aws_ubuntu_acme_frontend_img" {
  bucket_name         = data.hcp_packer_version.ubuntu_acme_frontend.bucket_name
  version_fingerprint = data.hcp_packer_version.ubuntu_acme_frontend.fingerprint
  platform            = "aws"
  region              = var.aws_region
}
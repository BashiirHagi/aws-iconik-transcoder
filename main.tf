provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source         = "./modules/S3"
  aws_s3_bucket  = var.aws_s3_bucket
  sse_algorithm  = var.sse_algorithm
  status         = var.status
  tags           = var.tags
}

module "ec2_instance" {
  source              = "./modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_group_id   = var.security_group_id
  key_name            = var.key_name
  iam_instance_profile = var.iam_instance_profile
}
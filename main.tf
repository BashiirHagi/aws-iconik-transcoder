provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "ec2_instance" {
  source        = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnet_id
  key_name      = var.key_name
}

module "s3_bukcet" {
  source        = "./modules/S3"
  aws_s3_bucket = var.aws_s3_bucket
  status        = var.status
  sse_algorithm = var.sse_algorithm
  tags          = var.tags
}

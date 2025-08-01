provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "ec2_instance" {
  source                    = "./modules/ec2"
  vpc_id                    = module.vpc.vpc_id
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.public_subnet_id
  key_name                  = var.key_name
  asg_name                  = var.asg_name
  asg_max_size              = var.asg_max_size
  asg_min_size              = var.asg_min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete_status       = var.force_delete_status
  vpc_zone_identifier       = [module.vpc.public_subnet_id]
}

module "s3_bukcet" {
  source        = "./modules/S3"
  aws_s3_bucket = var.aws_s3_bucket
  status        = var.status
  sse_algorithm = var.sse_algorithm
  tags          = var.tags
}

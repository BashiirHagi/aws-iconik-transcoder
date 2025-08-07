aws_region = "eu-west-2" 

# VPC and Subnet configuration
vpc_cidr_block     = "192.168.0.0/16"
public_subnet_cidr = "192.168.1.0/24"
private_subnet_cidr = "192.168.2.0/24"
availability_zone  = ["eu-west-2b", "eu-west-2c"]

# EC2 
ami_id                    = "ami-0c06487bdfcf8c68c"
instance_type             = "t3.micro"
key_name                  = "my_keys"
asg_name                  = "iconik-transcoder-asg"
asg_max_size              = 2
asg_min_size              = 1
health_check_grace_period = 300
health_check_type         = "EC2"
desired_capacity          = 2
force_delete_status       = true
vpc_zone_identifier       = ["subnet-021f21dcb51ba0b8b", "subnet-0129554e8d0225801"]

# S3
aws_s3_bucket = "iconik-ingest-bashiir2"
status        = "Enabled"
sse_algorithm = "AES256"
tags = {
  Name        = "iconik-ingest"
  environment = "Development"
}
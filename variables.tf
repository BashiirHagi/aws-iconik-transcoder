variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_s3_bucket" {
  type    = string
  default = "iconik-master-ingest-bashiir"
}

variable "sse_algorithm" {
  description = "S3 server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

variable "status" {
  description = "S3 bucket versioning status"
  type        = string
  default     = "Enabled"
}

variable "tags" {
  description = "A map of tags to add to all the resources"
  type        = map(string)
  default = {
    Name        = "iconik-master-ingest"
    environment = "Development"
  }
}

///EC2

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance (e.g. custom iconik image or Ubuntu base)"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "The Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "The Security Group ID to associate with the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to allow SSH access"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile name that grants necessary permissions (e.g., S3 access)"
  type        = string
}
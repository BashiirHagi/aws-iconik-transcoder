##Global variable
variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
}

##VPC 
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the public subnet"
  type        = string
}

##EC2 
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

##S3

variable "aws_s3_bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "status" {
  description = "Versioning status (Enabled or Suspended)"
  type        = string
}

variable "sse_algorithm" {
  description = "SSE algorithm for S3 encryption"
  type        = string
  default     = "AES256"
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
}
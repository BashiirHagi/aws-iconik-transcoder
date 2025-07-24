variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
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

variable "key_name" {
  description = "The name of the EC2 Key Pair to allow SSH access"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the security group"
  type        = string
}

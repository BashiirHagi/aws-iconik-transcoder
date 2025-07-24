//S3

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
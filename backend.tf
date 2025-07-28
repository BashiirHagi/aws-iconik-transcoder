terraform {  
  backend "s3" {  #Using S3 native locking
    bucket       = "tf-state-iconik"  
    key          = "dev/terraform.tfstate"  
    region       = "eu-west-2"  
    encrypt      = true  
  }  
}
# AWS + iconik Transcoder Integration

This project provisions a secure and automated AWS infrastructure for integrating with the iconik Media Asset Management (MAM) system. It enables the upload of master content to an S3 bucket and automatically triggers the iconik edge transcoder to generate web proxies for seamless preview in the iconik Web UI.

## Features

- Private VPC with public subnet and internet access  
- Secure S3 bucket for master content ingestion  
- EC2 instance running iconik edge transcoder  
- IAM roles with scoped S3 access  
- AMI-compatible deployment  
- Modular and reusable Terraform setup

## Architecture

![Architecture Diagram](./aws-iconik-transcoder.png)

## Module Structure

```bash
aws-iconik-transcoder/
├── .terraform/                       
├── modules/
│   ├── ec2/
│   │   ├── ec2.tf                   
│   │   ├── outputs.tf                
│   │   └── variables.tf              
│   ├── S3/
│   │   ├── s3.tf                     
│   │   ├── outputs.tf                
│   │   └── variables.tf             
│   └── vpc/
│       ├── vpc.tf                    
│       ├── outputs.tf                
│       └── variables.tf             
├── .gitignore
├── aws-iconik-transcoder.png        
├── main.tf                          
├── provider.tf                      
├── README.md                        
├── terraform.tfstate                
├── terraform.tfstate.backup         
├── terraform.tfvars                 
└── variables.tf                     
```

## Requirements

- Terraform >= 1.4.0  
- AWS CLI configured with access keys 
- Iconik web portal access to - https://preview.iconik.cloud/
- Iconik edge transcoder installer 

## How to Use

1. **Clone the Repo**
   ```bash
   git clone https://github.com/your-org/aws-iconik-transcoder.git
   cd aws-iconik-transcoder
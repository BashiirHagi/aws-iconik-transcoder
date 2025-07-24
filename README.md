# AWS + iconik Transcoder Integration

This project provisions a secure and automated AWS infrastructure for integrating with the iconik Media Asset Management (MAM) system. It enables the upload of master content to an S3 bucket and automatically triggers the iconik edge transcoder to generate web proxies for seamless preview in the iconik Web UI.

## Features

- AWS VPC with public subnet and internet gateway attached
- S3 bucket provisioned for master content ingestion for media assets
- Linux Ubuntu EC2 instance with iconik edge transcoder installed
- AMI created for Iconik edge transcoder for reusability 
- Terraform Modules configured for AWS services - EC2, S3 & VPC

## Architecture

![Architecture Diagram](./aws-iconik-transcoder.png)

## Project Structure

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
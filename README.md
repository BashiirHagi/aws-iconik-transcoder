# AWS iconik Transcoder Integration Project

This project provisions a secure and automated AWS infrastructure for integrating the iconik Media Asset Management (MAM) system for media asset uploads. It enables the upload of master content into an S3 bucket and automatically triggers the iconik edge transcoder to generate web proxies for seamless viewing in the iconik Web portal.

## Features

- AWS VPC, public subnet and internet gateway provisioned for internet access
- S3 bucket provisioned for master content ingestion 
- Linux Ubuntu EC2 instance provisioned and iconik edge transcoder installed
- AMI image created for Iconik edge transcoder to improve reusability 
- Terraform Modules configured to automate AWS deployments - EC2, S3 & VPC. 
- AWS services isolated in separate Terraform folders in the Child modules with service.tf, variables.tf and output.tf defined. 
- Local terraform state used to manage the state of the remote infrastructure 
- Architecture diagram demonstrating system components created in Excalidraw, to improve understanding of data flow and service interactions. 

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
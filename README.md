# AWS iconik Transcoder Integration Project

This project provisions a secure and automated AWS infrastructure for integrating the iconik Media Asset Management (MAM) system for media asset uploads into S3. It enables the upload of master content into an S3 bucket and automatically triggers the iconik edge transcoder to generate web proxies for seamless viewing in the iconik web portal.

## Features

- AWS VPC, public/private subnet and internet gateway have been provisioned for secure internet access
- Multi-AZ deployment implemented in the VPC to ensure high avaialbilty (HA) and prevent single point of failure 
- S3 bucket provisioned for master content ingestion and bucket permissions configured
- Linux Ubuntu EC2 instance provisioned in a auto-scaling group for scalability purposes
- AMI image created for Iconik edge transcoder to improve reusability 
- Terraform Modules configured to automate AWS deployments - EC2, S3 & VPC
- Terraform configuration for AWS service isolated in separate Child modules folders - containing service.tf, variables.tf and output.tf
- Used S3 remote backend to store the Terraform state for the AWS infrastructure 
- Architecture diagram demonstrating system components created in Excalidraw, to improve understanding of data flow and service interactions

## High-Level Architecture

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
├── backend.tf          
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
- Iconik edge transcoder installed on your EC2 instance

## How to use: 
To utilise the Terraform modules to deploy AWS resources in your environment, update the values in the terraform.tfvars files with valid entries and run - terraform apply. 

```bash
aws_region = ""

# VPC and Subnet configuration
vpc_cidr_block     = ""
public_subnet_cidr = ""
private_subnet_cidr = ""
availability_zone  = ""

# EC2 
ami_id                    = ""
instance_type             = ""
key_name                  = ""
asg_name                  = ""
asg_max_size              = ""
asg_min_size              = ""
health_check_grace_period = ""
health_check_type         = ""
desired_capacity          = ""
force_delete_status       = ""
vpc_zone_identifier       = [""]

# S3
aws_s3_bucket = ""
status        = ""
sse_algorithm = ""
tags = {
  Name        = ""
  environment = ""
}

```

## Transcoder Installations steps: 
- Navigate to the AWS region you want to provision the EC2 instance in
- Launch EC2 instance - selecting instance type, OS base image (e.g. Ubuntu 24.04) 
- Download SSH key to your downloads folder and set appropriate permisions
- SSH into the EC2 instance via the terminal to establish a secure connection 

Once connected to the instance, create the transcoder installation script by following the below steps: 
- Run vim transcoder-install.sh in the terminal 
- Add #!bin/bash to the file header 
- Copy the below package installation commands to the file 

```bash
sudo apt-get install wget gnupg 
sudo tee -a /etc/apt/sources.list.d/iconik.list >/dev/null << EOF
deb [signed-by=/usr/share/keyrings/iconik.gpg] https://packages.iconik.io/deb/ubuntu ./noble main
EOF
curl https://packages.iconik.io/deb/ubuntu/dists/noble/iconik_package_repos_pub.asc |\
sudo gpg --dearmor -o /usr/share/keyrings/iconik.gpg    
sudo apt-get update
sudo apt-get install iconik-edge-transcoder
sudo apt-get install ffmpeg imagemagick poppler-utils ghostscript dcraw libimage-exiftool-perl
sudo apt-get install nscd
sudo apt-get install exiftool
```

- Save the changes by running - wq!

## Edit the configuration file (config.ini) by performing the following steps: 

- Navigate to the /etc/iconik/iconik_edge_transcoder/config.ini path in your server
- Run - vim config.ini
- Copy the below code block the file and update the relevant parameters for your environment

```bash

[main]

app-id = [Add app-id from settings > application tokens in the iconik UI]
iconik-url = [Add https url for iconik platform]
auth-token = [Add Application Token from settings > application tokens in the iconik UI ]
sleep-time = 10
max-transcoding-jobs = 4
log-filename = /var/log/iconik/iconik_edge_transcoder/default.log
use-file-cache-proxy = true
session-timeout = 60
image-magick-config = /etc/iconik/iconik_edge_transcoder/image_magick_config
```
- save the changes by running - wq!

## Transcoder proxy startup services and enablement:
Once you have updated the config.ini file, create the transcoder services script by following the below steps: 
- Run vim transcoder-services.sh 
- Add #!bin/bash to the file header 
- Copy the following code block to the file 

```bash
- copy the following contents inside: 
- sudo systemctl enable iconik-file-cache
- sudo systemctl start iconik-file-cache   
- sudo systemctl enable iconik-edge-transcoder
- sudo systemctl start iconik-edge-transcoder
```

- Save the changes by running - wq!
- Run chmod 700 transcoder-services.sh to give the script secure executable permissions


## AWS AMI setup 
To create the AMI image containing the iconik edge transcoder, perform the following steps: 
- Navigate to the EC2 intances console in your AWS account
- Select the instance that you want to create an AMI image for
- Click on Actions
- Click on Image and Templates
- Click on Create Image
- AMI image has been created now, and will be available in the EC2 AMIs console. You can now use this AMI to quickly launch instances with the iconik edge transcoder installed. 

## Future Improvements I would implement 
- ### High availability:
To ensure the high availability of the platform I would deploy the iconik Edge Transcoder across multiple subnets, availability zones and regions. This would improve the fault-tolerance and prevent a single point of failure we have now. 

- ### Security Enhancements:
To increase the security of the workloads I would implement the following: 

- Enforce least privillege access in the S3 bucket policy 
- AWS Systems Manager (SSM) for secure access as an alternative to SSH access
- I would enable AWS Macie, VPC flow logs and AWS GuardDuty which would increase the visibility and secutity of the platform


- ### Scalability:
To further increase the scalability of the compute resources I would use Elastic Container services (ECS) with fargat launch type to run the iconik Edge Transcoder. This will allow me to utilise the benefits of serverless and containerisation without managing the underlying infrastructure. 


- ### Cost Efficiency:
To reduce the costs incurred in the platform, I would integrate VPC gateway endpoints to allow the compute resources in the VPC to securely connect to the S3 bucket without traversing the public internet. This would create a secure private connection between the services and prevent network traffic from leaving the VPC, greatly reducing egress traffic charges. 


Links: 

https://help.iconik.backlight.co/hc/en-us/articles/25303770933271-iconik-Architecture-Overview

https://help.iconik.backlight.co/hc/en-us/articles/25304180048663-Installing-iconik-Edge-Transcoder-on-Ubuntu-24-04

https://help.iconik.backlight.co/hc/en-us/articles/25027458899351-AWS-storage


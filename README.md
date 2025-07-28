# AWS iconik Transcoder Integration Project

This project provisions a secure and automated AWS infrastructure for integrating the iconik Media Asset Management (MAM) system for media asset uploads. It enables the upload of master content into an S3 bucket and automatically triggers the iconik edge transcoder to generate web proxies for seamless viewing in the iconik Web portal.

## Features

- AWS VPC, public subnet and internet gateway provisioned for internet access
- S3 bucket provisioned for master content ingestion 
- Linux Ubuntu EC2 instance provisioned in a auto-scaling group for scalability with iconik edge transcoder installed
- AMI image created for Iconik edge transcoder to improve reusability 
- Terraform Modules configured to automate AWS deployments - EC2, S3 & VPC. 
- AWS services isolated in separate Terraform folders in the Child modules with service.tf, variables.tf and output.tf defined. 
- Local terraform state used to manage the state of the remote infrastructure 
- Architecture diagram demonstrating system components created in Excalidraw, to improve understanding of data flow and service interactions. 

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
To use the Terraform modules for the deployment of resources, update the values in the terraform.tfvars files with entries for your environment and run - terraform apply. 

```bash
aws_region = ""

# VPC and Subnet configuration
vpc_cidr_block     = ""
public_subnet_cidr = ""
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
- Navigate to AWS region you want to provision EC2 instance in
- Launch EC2 instance - selecting instance type, OS base image (e.g. Ubuntu 24.04)
- Download SSH key and set appropriate permisions
- SSH into the EC2 instance via the terminal 

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

- Navigate to the /etc/iconik/iconik_edge_transcoder/config.ini path
- Run - vim config.ini
- Copy the below code block the file and update the relevant parameters for your environment

```bash

[main]

app-id = [Add app-id from settings > application tokens]
iconik-url = [Add https url for iconik platform]
auth-token = [Add Application Token from settings > application tokens ]
sleep-time = 10
max-transcoding-jobs = 4
log-filename = /var/log/iconik/iconik_edge_transcoder/default.log
use-file-cache-proxy = true
session-timeout = 60
image-magick-config = /etc/iconik/iconik_edge_transcoder/image_magick_config
```
- save the changes by running - wq!

## Transcoder proxy startup services and enablement:
Create the transcoder services script with the following commands:  
- vim transcoder-services.sh 
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
- Run chmod 700 transcoder-services.sh to give the script executable permissions


## AWS AMI setup 
- Navigate to the EC2 intances console 
- Select the instance that you want to create an AMI image for
- Click on Actions 
- Click on Image and Templates
- Click on Create Image
- AMI image is created now, and can be used to launch instances, retaining OS image and installed tools & dependencies 

## Future Improvements 
- High availability - Deploy the transcoder instances across multiple subnets, availability zones and regions
- Security - Deploy the transcoder instances in private subnets ensuring its secure, across multiple availability zones connecting to NAT gateways for public internet access. 
- Scalability - Autoscaling groups, Use ECS Fargate launch type to deploy the transcoder (serverless), 
- Cost efficiency - Utilise VPC endpoitns to allow resources in the VPC to connect securely to the S3 buckets to access data. This is to prevent traffic leaving the private network and to reduce egress traffic charges. 

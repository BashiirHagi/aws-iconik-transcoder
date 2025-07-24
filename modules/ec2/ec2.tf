resource "aws_instance" "iconik_transcoder" {
  ami                    = var.ami_id                   # e.g. custom AMI or Ubuntu AMI
  instance_type          = var.instance_type            # e.g. t3.medium
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile     # IAM role with S3 and iconik access

  tags = {
    Name = "iconik-edge-transcoder"
    Project = "iconik-transcoder"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  # Optional: if not using baked AMI
  # user_data = file("${path.module}/install.sh")

  lifecycle {
    create_before_destroy = true
  }
}
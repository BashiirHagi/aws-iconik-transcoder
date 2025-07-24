resource "aws_instance" "iconik_transcoder" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.iconik_sg.id]
  key_name        = var.key_name

  tags = {
    Name    = "iconik-edge-transcoder"
    Project = "iconik-transcoder"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "iconik_sg" {
  name        = "iconik-ec2-sg"
  description = "Allow SSH from all hosts"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "iconik-transcoder-sg"
  }
}
## launch template for asg
resource "aws_launch_template" "launch-template-asg" {
  name_prefix   = "launch-template-iconik"
  image_id      = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.iconik_sg.id]
}

resource "aws_autoscaling_group" "transcoder-asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete_status
  vpc_zone_identifier       = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.launch-template-asg.id
    version = "$Latest"
  }

  tag {
    key   = "Name"
    value = "iconik-transcoder-instances"

    propagate_at_launch = true
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
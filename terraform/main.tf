# Create Blue Instance
resource "aws_instance" "blue" {
  ami           = var.AWS_AMI_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME

  tags = {
    Name = "blue-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo docker run -d -p 3000:3000 ghcr.io/<your-username>/blue-green-app:latest
              EOF
}

# Create Green Instance
resource "aws_instance" "green" {
  ami           = var.AWS_AMI_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = var.KEY_NAME

  tags = {
    Name = "green-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo docker run -d -p 3000:3000 ghcr.io/<your-username>/blue-green-app:latest
              EOF
}

#Security Group for Instances
resource "aws_security_group" "instance_sg" {
  name        = "blue-green-sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch available subnets in the default VPC
data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Load Balancer
resource "aws_lb" "blue_green_lb" {
  name               = "blue-green-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instance_sg.id]
  subnets            = data.aws_subnets.available.ids

  enable_deletion_protection = false
}

# Target Group
resource "aws_lb_target_group" "blue_green_tg" {
  name     = "blue-green-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path = "/health"
  }
}

# Attach Instances to Target Group
resource "aws_lb_target_group_attachment" "blue" {
  target_group_arn = aws_lb_target_group.blue_green_tg.arn
  target_id        = aws_instance.blue.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "green" {
  target_group_arn = aws_lb_target_group.blue_green_tg.arn
  target_id        = aws_instance.green.id
  port             = 3000
}

# Listener
resource "aws_lb_listener" "blue_green_listener" {
  load_balancer_arn = aws_lb.blue_green_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_green_tg.arn
  }
}

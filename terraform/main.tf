terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_launch_configuration" "workhorse" {
  image_id        = "ami-0bad4a5e987bdebde"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "workhorse_asg" {
  launch_configuration = launch_configuration.workhorse.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.alb_tg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 2

  tag {
    key                 = "Name"
    value               = "workhorse_asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "balancer" {
  name               = "my-cool-balancer"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "instance" {
  name = "workhorse-sg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name = "workhorse-alb-sg"

  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
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

resource "aws_lb_target_group" "alb_tg" {
  name = "alb-tg"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "alb_lr" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    field  = "path-pattern"
    values = ["*"]
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "makushatnik-state-bucket"
    key    = "db/postgres.tfstate"
    region = "us-east-2"
  }
}
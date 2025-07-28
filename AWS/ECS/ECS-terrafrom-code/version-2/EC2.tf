resource "aws_launch_template" "ecs_lt" {
 name_prefix   = "ecs-template"
 image_id      = "ami-0b42a7f312a9ed8a5"
 instance_type = "t3.micro"

 key_name               = "vignesh"
 vpc_security_group_ids = [aws_security_group.security_group.id]
 iam_instance_profile {
   name = aws_iam_instance_profile.ecs_instance_profile.name
 }

 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp2"
   }
 }

 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "ecs-instance"
   }
 }

 user_data = filebase64("${path.module}/ecs.sh")
}

resource "aws_autoscaling_group" "ecs_asg" {
 vpc_zone_identifier = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
 desired_capacity    = 2
 max_size            = 3
 min_size            = 1

 launch_template {
   id      = aws_launch_template.ecs_lt.id
   version = "$Latest"
 }
 

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}

resource "aws_lb" "ecs_alb" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.security_group.id]
 subnets = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
# subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]

 tags = {
   Name = "ecs-alb"
 }
}

#resource "aws_lb_listener" "ecs_alb_listener" {
# load_balancer_arn = aws_lb.ecs_alb.arn
# port              = 80
# protocol          = "HTTP"
#
# default_action {
#   type             = "forward"
#   target_group_arn = aws_lb_target_group.ecs_tg.arn
# }
#}

#resource "aws_lb_listener" "http_redirect" {
#  load_balancer_arn = aws_lb.ecs_alb.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}





resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_cert.arn  # 👈 Your ACM cert here

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn  # 👈 Your frontend TG here
  }
}

# ✅ General ECS SG (SSH, HTTP, HTTPS from anywhere)
resource "aws_security_group" "security_group" {
  name   = "ecs-security-group"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere (insecure)"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

# ✅ Frontend SG (allow inbound HTTP)
resource "aws_security_group" "frontend_sg" {
  name   = "ecs-frontend-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups          = [aws_security_group.security_group.id] 
    #cidr_blocks = ["0.0.0.0/0"]  # Public access for HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ✅ Backend SG (no open ports to public, only allows 8080 from frontend SG)
resource "aws_security_group" "backend_sg" {
  name   = "ecs-backend-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    security_groups          = [aws_security_group.security_group.id]  # Reference your ALB SG here
    description              = "Allow ALB access to backend on port 8080"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




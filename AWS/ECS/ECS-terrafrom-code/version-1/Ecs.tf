resource "aws_ecs_cluster" "ecs_cluster" {
 name = "my-ecs-cluster"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
 name = "test1"

 auto_scaling_group_provider {
   auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

   managed_scaling {
     maximum_scaling_step_size = 1000
     minimum_scaling_step_size = 1
     status                    = "ENABLED"
     target_capacity           = 3
   }
 }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
 cluster_name = aws_ecs_cluster.ecs_cluster.name

 capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
 }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "my-ecs-task"
  network_mode       = "bridge"
  execution_role_arn = "arn:aws:iam::438465168997:role/ecsTaskExecutionRole"
  cpu                = 256
  memory             = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name       = "dockergs"
      image      = "438465168997.dkr.ecr.us-east-1.amazonaws.com/emsops/vignesh-frontend:v1.0.0"
      cpu        = 256
      memory     = 512
      essential  = true

      # Entry point and command for typical React container
      #entryPoint = ["sh", "-c"],
      #command    = ["npm start"],

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ],

      environment = [
        {
          name  = "REACT_APP_BACKEND_URL"
          value = "http://${aws_lb.ecs_alb.dns_name}"
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/emsops-frontend"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])

depends_on = [
    aws_cloudwatch_log_group.frontend_logs,
    aws_lb.ecs_alb,
    aws_ecs_service.ecs_service_backend
  ]
}


resource "aws_ecs_service" "ecs_service" {
 name            = "my-ecs-service"
 cluster         = aws_ecs_cluster.ecs_cluster.id
 task_definition = aws_ecs_task_definition.ecs_task_definition.arn
 desired_count   = 1

 #network_configuration {
 #  subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
 #  security_groups = [aws_security_group.security_group.id]
 #}

 
 placement_constraints {
   type = "distinctInstance"
 }

 capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
   weight            = 100
 }

 load_balancer {
   target_group_arn = aws_lb_target_group.ecs_tg.arn
   container_name   = "dockergs"
   container_port   = 3000
 }
 force_new_deployment = true 

 depends_on = [aws_autoscaling_group.ecs_asg]
}

variable "db_name" {
  default = "ems"
}

resource "aws_ecs_task_definition" "ecs_task_definition_backend" {
  family                   = "emsops-backend-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = "arn:aws:iam::438465168997:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "emsops-backend"
      image     = "438465168997.dkr.ecr.us-east-1.amazonaws.com/emsops/vignesh-backend:v1.0.0"
                
      cpu       = 256
      memory    = 512
      essential = true
     # command   = [
     #   "sh",
     #   "-c",
     #   "mysql -h ${aws_db_instance.ems.address} -uadmin -padmin123 -e 'CREATE DATABASE IF NOT EXISTS ${var.db_name};' && java -jar /app/app.jar"
     # ],
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = "admin"
        },
        {
          name  = "SPRING_DATASOURCE_PASSWORD"
          value = "admin123"
        },
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:mysql://${aws_db_instance.ems.address}:3306/ems?useSSL=false&allowPublicKeyRetrieval=true"
        },
        {
          name  = "SPRING_JPA_HIBERNATE_DDL_AUTO"
          value = "update"
        }
      ],
      logConfiguration = {
                         logDriver = "awslogs"
                         options = {
                         awslogs-group         = "/ecs/emsops-backend"
                         awslogs-region        = "us-east-1"
                         awslogs-stream-prefix = "backend"
  }
}

    }
  ])
   depends_on = [
    aws_db_instance.ems,
    aws_autoscaling_group.ecs_asg,
    #aws_ecs_service.ecs_service_backend
  ]

}


resource "aws_ecs_service" "ecs_service_backend" {
  name            = "emsops-backend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition_backend.arn
  desired_count   = 1
  

  #network_configuration {
  #  subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
  #  security_groups = [aws_security_group.security_group.id]
  #}

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  placement_constraints {
    type = "distinctInstance"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg_backend.arn
    container_name   = "emsops-backend"
    container_port   = 8080
  }


  depends_on = [aws_autoscaling_group.ecs_asg]
}


resource "aws_lb_target_group" "ecs_tg_backend" {
  name_prefix = "ecsbk-"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/api/health"  # or just "/" if your backend root works
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.ecs_alb_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg_backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}



resource "aws_lb_target_group" "ecs_tg" {
  name_prefix = "ecstg-" # allows create_before_destroy
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"              # Match your app's root path
    protocol            = "HTTP"
    matcher             = "200-399"        # Accepts redirects and other valid responses
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "ems" {
  name       = "rds-ems-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id,
  ]
  tags = {
    Name = "rds-ems-subnet-group"
  }

}

# 2) SG for RDS that allows MySQL from your ECS instances
resource "aws_security_group" "rds" {
  name        = "rds-ems-sg"
  description = "Allow ECS tasks to connect to MySQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from ECS"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3) The RDS MySQL instance itself
resource "aws_db_instance" "ems" {
  identifier             = "ems-ops-db"
  engine                 = "mysql"
  engine_version         = "8.0.41"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"

  db_name                = "ems" # ✓ Correct property to create DB during provisioning
  username               = "admin"
  password               = "admin123"

  db_subnet_group_name   = aws_db_subnet_group.ems.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot    = true
  publicly_accessible    = true
  multi_az               = false

  tags = {
    Name = "ems-ops-db"
  }
}


resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/ecs/emsops-frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/emsops-backend"
  retention_in_days = 7
}



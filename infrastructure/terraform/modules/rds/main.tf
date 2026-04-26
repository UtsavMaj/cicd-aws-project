# modules/rds/main.tf

resource "aws_db_subnet_group" "main" {
  name       = "${lower(var.project_name)}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "${var.project_name}-db-subnet-group"
    Project = var.project_name
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${lower(var.project_name)}-rds-sg"
  description = "Allow PostgreSQL from EKS nodes only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-rds-sg"
    Project = var.project_name
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${lower(var.project_name)}-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.rds_instance_class
  allocated_storage      = 20
  storage_encrypted      = true
  db_name                = "userservice"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  backup_retention_period = 0
  multi_az               = false

  tags = {
    Name    = "${var.project_name}-postgres"
    Project = var.project_name
  }
}
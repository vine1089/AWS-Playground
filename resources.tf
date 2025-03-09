provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "operations_rds_db" {
  allocated_storage    = 20
  db_name              = "opsrdsdb1" 
  identifier           = "ops-rds-db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = aws_db_parameter_group.ops_rds_db_pg.name
  skip_final_snapshot  = true

  # Optional settings
  publicly_accessible  = false
  multi_az             = false
  backup_retention_period = 7
  backup_window        = "07:00-09:00"
  maintenance_window   = "Mon:00:00-Mon:03:00"
  vpc_security_group_ids = ["sg-0f7a0591daa553952", "sg-0e04ab2af6b46e654"]
  db_subnet_group_name = "ops-rds-subnet-group"
}

resource "aws_db_subnet_group" "ops_rds_subnet_group" {
  name       = "ops-rds-subnet-group"
  subnet_ids = ["subnet-086f5f383debb029c", "subnet-01e1905e68521ed18", "subnet-05e3ad5e5d82695b0", "subnet-0ff78a946b020c890"]

  tags = {
    Name = "Operations-RDS-Subnet-Group"
  }
}

resource "aws_db_parameter_group" "ops_rds_db_pg" {
  name        = "ops-rds-db-pg"
  family      = "mysql8.0"
  description = "DB parameter group for ops RDS"

  parameter {
    name  = "max_connections"
    value = "100"
  }
}

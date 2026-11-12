# -------------------------------------------------------------------
# RDS サブネットグループ
# -------------------------------------------------------------------
resource "aws_db_subnet_group" "main" {
  name        = "rds-subnet-group"
  description = "Private subnets for RDS"
  subnet_ids  = [aws_subnet.private_a.id, aws_subnet.private_c.id]
  tags        = { Name = "RDS-Subnet-Group" }
}

# -------------------------------------------------------------------
# RDS MySQL
# -------------------------------------------------------------------
resource "aws_db_instance" "main" {
  allocated_storage           = 20
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  instance_class              = "db.t4g.micro"
  port                        = 3306
  storage_type                = "gp2"
  backup_retention_period     = 1
  username                    = "admin"
  password                    = var.db_password
  db_name                     = "appdb"
  engine                      = "mysql"
  engine_version              = var.db_engine_version
  license_model               = "general-public-license"
  db_subnet_group_name        = aws_db_subnet_group.main.name
  publicly_accessible         = false
  storage_encrypted           = true
  multi_az                    = false
  vpc_security_group_ids      = [aws_security_group.rds.id]
  deletion_protection         = true
  skip_final_snapshot         = true

  tags = { Name = "MyRDS" }
}

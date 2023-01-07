# ----------------------
# RDSの作成
# ----------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}
# ----------------------
# RDS オプショングループの作成
# ----------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  # 関連付けるエンジン名（MySQLなど）
  engine_name          = "mysql"
  # 関連付けるエンジンバージョン
  major_engine_version = "8.0"
}
# ------------------------
# RDS サブネットグループ
# ------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-standgroup"
    Project = var.project
    Env     = var.environment
  }
}
# ------------------------
# RDS インスタンスに使用するパスワード（ランダム文字列）
# ------------------------
resource "random_string" "db_password" {
  length  = 16
  special = false
}
# ------------------------
# RDS の作成
# ------------------------
resource "aws_db_instance" "mysql_standalone" {
  # RDSの基本設定
  engine         = "mysql"
  engine_version = "8.0.28"
  identifier     = "${var.project}-${var.environment}-mysql-standalone"
  # ユーザー情報
  username = "admin"
  password = random_string.db_password.result
  # インスタンスの設定
  instance_class = "db.t2.micro"
  # 割り当てるストレージサイズ
  allocated_storage = 20
  # 割り当てる最大ストレージサイズ
  max_allocated_storage = 50
  # ストレージタイプ
  storage_type = "gp2"
  # DBの暗号化
  storage_encrypted = false
  # マルチAZの設定
  multi_az          = false
  availability_zone = "ap-northeast-1a"
  # DBのサブネットグループの設定
  db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  # DBのセキュリティグループの設定
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  name                 = "tastylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name
  # DBバックアップ時間
  backup_window = "04:00-05:00"
  # DBのバックアップを残す期間
  backup_retention_period = 7
  # メンテナンスの時間
  maintenance_window = "Mon:05:00-Mon:08:00"
  # マイナーバージョンアップグレードの有無
  auto_minor_version_upgrade = false
  # 削除保護
  deletion_protection = false
  # 削除時のスナップショットをスキップするか
  skip_final_snapshot = true
  # 即時反映させるか
  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------
# セキュリティグループを作成
# ----------------------------
# Webセキュリティグループの作成
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web front role security group"
  # 配置するVPCを指定
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}
# Webセキュリティグループのルールを作成
resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  # インバウンドルールであることを明示
  type = "ingress"
  # プロトコルを指定
  protocol = "tcp"
  # Http = Port 80
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  # インバウンドルールであることを明示
  type = "ingress"
  # プロトコルを指定
  protocol = "tcp"
  # Https = Port 443
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_in_tcp3000" {
  security_group_id = aws_security_group.web_sg.id
  # アウトバウンドルールであることを明示
  type = "egress"
  # プロトコルを指定
  protocol  = "tcp"
  from_port = 3000
  to_port   = 3000
  # どこから入ってくるか指定
  source_security_group_id = aws_security_group.app_sg.id
}

# Webアプリケーション用のセキュリティグループ
resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_security_group_rule" "app_in_tcp3000" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.web_sg.id
}
resource "aws_security_group_rule" "app_out_http" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  # プレフィックスリストを指定
  prefix_list_ids = [data.aws_prefix_list.s3_pl.id]
}
resource "aws_security_group_rule" "app_out_https" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  # プレフィックスリストを指定
  prefix_list_ids = [data.aws_prefix_list.s3_pl.id]
}
resource "aws_security_group_rule" "app_out_tcp3306" {
  security_group_id        = aws_security_group.app_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.db_sg.id
}

# 運用管理用のセキュリティグループ
resource "aws_security_group" "opmng_sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "operation and mangement role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}
# SSHのセキュリティグループを作成
resource "aws_security_group_rule" "opmng_in_ssh" {
  security_group_id = aws_security_group.opmng_sg.id
  # インバウンドルールであることを明示
  type = "ingress"
  # プロトコルを指定
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = ["0.0.0.0/0"]
}
# TCP3000のセキュリティグループを作成
resource "aws_security_group_rule" "opmng_in_tcp3000" {
  security_group_id = aws_security_group.opmng_sg.id
  # インバウンドルールであることを明示
  type = "ingress"
  # プロトコルを指定
  protocol    = "tcp"
  from_port   = 3000
  to_port     = 3000
  cidr_blocks = ["0.0.0.0/0"]
}
# HTTPアウトバウンドのセキュリティグループを作成
resource "aws_security_group_rule" "opmng_out_http" {
  security_group_id = aws_security_group.opmng_sg.id
  # アウトバウンドルールであることを明示
  type = "egress"
  # プロトコルを指定
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = ["0.0.0.0/0"]
}
# HTTPSアウトバウンドのセキュリティグループを作成
resource "aws_security_group_rule" "opmng_out_https" {
  security_group_id = aws_security_group.opmng_sg.id
  # アウトバウンドルールであることを明示
  type = "egress"
  # プロトコルを指定
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_blocks = ["0.0.0.0/0"]
}
# データベース用のセキュリティグループ
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}
# DB3306のセキュリティグループを作成
resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id = aws_security_group.db_sg.id
  # インバウンドルールであることを明示
  type = "ingress"
  # プロトコルを指定
  protocol  = "tcp"
  from_port = 3306
  to_port   = 3306
  # どこから入ってくるか指定
  source_security_group_id = aws_security_group.app_sg.id
}

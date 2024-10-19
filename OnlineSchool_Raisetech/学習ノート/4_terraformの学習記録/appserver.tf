# -----------------------------------
# Key Pair
# -----------------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  # キーペア作成時の公開鍵を指定
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}
# -----------------------------------
# SSM（SystemManager）パラメータストア
# -----------------------------------
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql_standalone.address
}
resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql_standalone.port
}
resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql_standalone.name
}
resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.username
}
resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
  type  = "SecureString"
  value = aws_db_instance.mysql_standalone.password
}
# 「data.tf」にてイメージのフィルターを変更したため、以下コメントアウト(インスタンスではなく作成したAMIを指定)
# # -----------------------------------
# # インスタンス作成
# # -----------------------------------
# resource "aws_instance" "app_server" {
#   ami                         = data.aws_ami.app.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_subnet_1a.id
#   associate_public_ip_address = true
#   # IAMロールを適用（インスタンスプロフィール）
#   iam_instance_profile = aws_iam_instance_profile.app_ec2_profile.name
#   vpc_security_group_ids = [
#     aws_security_group.app_sg.id,
#     aws_security_group.opmng_sg.id
#   ]
#   # キーペアとの関連付け。キーペアのネームは「key_name」となる
#   key_name = aws_key_pair.keypair.key_name

#   tags = {
#     Name    = "${var.project}-${var.environment}-app-ec2"
#     Project = var.project
#     Env     = var.environment
#     # アプリケーション用のサーバーであるタグ付け
#     Type = "app"
#   }
# }

# -----------------------------------
# 起動テンプレート 作成
# -----------------------------------
# アプリケーションサーバー用

resource "aws_launch_template" "app_lt" {
  # デフォルトバージョンの自動更新
  update_default_version = true

  name = "${var.project}-${var.environment}-app-lt"
  # AMIを指定
  image_id = data.aws_ami.app.id
  # キーペアの指定
  key_name = aws_key_pair.keypair.key_name

  # 起動されるインスタンスに付与されるタグ
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project}-${var.environment}-app-ec2"
      Project = var.project
      Env     = var.environment
      # アプリケーション用のサーバーであるタグ付け
      Type = "app"
    }
  }
  # ネットワーク設定
  network_interfaces {
    # パブリックIPを付与するか
    associate_public_ip_adress = true
    security_groups = [
      aws_security_group.app_sg.id,
      aws_security_group.opmng_sg.id
    ]
    # インスタンスが落ちた時、他のネットワークインターフェースも削除する
    delete_on_termination = true
  }
  # EC2にIAMロールを割り当てる
  iam_instance_profile {
    name = aws_iam_instance_profile.app_ec2_profile.name
  }
  # S3からソースコードを自動でダウンロードして、アプリケーションを立ち上げることを想定。
  # 初期化スクリプト「initialize」。バケット名を変更。

  # filebase64 エンコードを実施
  user_data = filebase64("./src/initialize.sh")
}
# -----------------------------------
# オートスケーリンググループ 作成
# -----------------------------------
resource "aws_autoscaling_group" "app_asg" {
  name = "${var.project}-${var.environment}-app-asg"

  # インスタンス最大個数
  max_size = 1
  # インスタンス最小個数
  min_size = 1
  # 希望するインスタンス個数
  desirerd_capacity = 1
  # ヘルスチェックを実施するタイミング。立ち上がってすぐではない。
  health_check_grace_period = 300
  # ヘルスチェックの方法
  health_check_type = "ELB"

  # オートスケーリングを実施するVPCを指定
  vpc_zone_identifier = [
    aws_subnet.public_subnet_1a.image_id,
    aws_subnet.public_subnet_1c.image_id
  ]
  # 関連付けるターゲットグループ（ELB）
  target_group_arns = [aws_lb_target_group.alb_target_group.arn]
  # 起動テンプレートの作成
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
      # 起動テンプレートの指定
      launch_template_id = aws_launch_template.app_lt.id
      # テンプレートのバージョンを指定
      version = "$Latest"
      }
      # インスタンスタイプの上書き設定
      override {
        instance_type = "t2-micro"
      }
    }
  }
}

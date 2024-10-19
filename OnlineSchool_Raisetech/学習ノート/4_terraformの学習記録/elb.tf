# ----------------------------
# ALBを作成
# ----------------------------
resource "aws_lb" "alb" {
  name = "${var.project}-${var.environment}-app-alb"
  # 内部向け
  internal = false
  # ロードバランサーのタイプ
  load_balancer_type = "application"
  # 適用するセキュリティグループを指定
  security_groups = [
    aws_security_group.web_sg.id
  ]
  # サブネットグループの指定
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]
}
# HTTPでロードバランサーが受け取れるようにリスナーを作成
resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  # HTTPを設定
  port     = 80
  protocol = "HTTP"
  # デフォルトアクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
# HTTPSでロードバランサーが受け取れるようにリスナーを作成
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  # HTTPSを設定
  port     = 443
  protocol = "HTTPS"
  # SSL系の証明書を指定
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.tokyo_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}
# ----------------------------
# ターゲットグループを作成
# ----------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name = "${var.project}-${var.environment}-app-tg"
  # 3000番ポートを受け付ける
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-tag"
    Project = var.project
    Env     = var.environment
  }
}
# # 「data.tf」のフィルター変更に伴いコメントアウト
# # ターゲットグループに所属させるEC2インスタンスを関連付ける
# resource "aws_lb_target_group_attachment" "instance" {
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   # 紐づけるインスタンス
#   target_id = aws_instance.app_server.id
# }

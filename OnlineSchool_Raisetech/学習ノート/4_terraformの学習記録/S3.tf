# バケット名の末尾にランダム文字列を追加する
resource "random_string" "s3_unique_key" {
  # 文字数
  length = 6
  # 大文字の使用是非
  upper = false
  # 小文字の使用是非
  lower = true
  # 数字の使用是非
  number = true
  # 特殊文字の使用是非
  special = false
}
#-----------------------
# S3 の作成
#-----------------------
  # バケットの作成
resource "aws_s3_bucket" "s3_static_bucket" {
  # ランダム文字列は「.result」
  bucket = "${var.project}-${var.environment}-static-bucket-${random_string.s3_unique_key.result}"
  # バージョニング設定
  versioning {
    enabled = false
  }
}
# アクセス制御
resource "aws_s3_bucket_public_access_block" "s3_static_bucket" {
  # バケット名
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  # 新しいACL設定をブロック
  block_public_acls       = true
  # 新しいバケットポリシーをブロック
  block_public_policy     = true
  # 公開ACL設定を無視するか
  ignore_public_acls      = true
  # 所有者とAWSサービスのみにアクセス制限
  restrict_public_buckets = false
  # 関係性の定義
  depends_on = [
    aws_s3_bucket_policy.s3_static_bucket
  ]
}
# ポリシーの定義
resource "aws_s3_bucket_policy" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.s3_static_bucket.json
}
# 下記データブロックにてポリシーを定める
data "aws_iam_policy_document" "s3_static_bucket" {
  statement {
    effect  = "Allow"
    actions = ["s3:Getobject"]
    # 全てのリソースを指定
    resources = ["${aws_s3_bucket.s3_static_bucket.arn}/*"]
    principals {
      # 誰に対して
      type = "*"
      # 全てのデータに対して
      identifiers = ["*"]
    }
  }
}
#-----------------------
# S3 デプロイ用（プライベート）バケットの作成
#-----------------------
# プライベートバケットの作成
resource "aws_s3_bucket" "s3_deploy_bucket" {
  # ランダム文字列は「.result」
  bucket = "${var.project}-${var.environment}-deploy-bucket-${random_string.s3_unique_key.result}"
  # バージョニング設定
  versioning {
    enabled = false
  }
}
# アクセス制御(上記と同内容)
resource "aws_s3_bucket_public_access_block" "s3_deploy_bucket" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # 関係性の定義
  depends_on = [
    aws_s3_bucket_policy.s3_deploy_bucket
  ]
}
# ポリシーの定義
resource "aws_s3_bucket_policy" "s3_deploy_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  policy = data.aws_iam_policy_document.s3_deploy_bucket.json
}
# 下記データブロックにてポリシーを定める
data "aws_iam_policy_document" "s3_deploy_bucket" {
  statement {
    effect  = "Allow"
    actions = ["s3:Getobject"]
    # 全てのリソースを指定
    resources = ["${aws_s3_bucket.s3_deploy_bucket.arn}/*"]
    principals {
      # 誰に対して
      type = "AWS"
      # EC2からのアクセス指定のため
      identifiers = [aws_iam_role.app_iam_role.arn]
    }
  }
}

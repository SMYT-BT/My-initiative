# ------------------------------
# IAMロールの作成
# ------------------------------
# インスタンスプロフィール
resource "aws_iam_instance_profile" "app_ec2_profile" {
  # IAMロールと紐づけるため同名にする
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}
# IAMロール
resource "aws_iam_role" "app_iam_role" {
  name = "${var.project}-${var.environment}-app-iam-role"
  # ポリシーの形式がjson形式であるため、.jsonとする
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
# 信頼ポリシー
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    # 各単語の1文字目を大文字で書くcamel caseで書かないといけない
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      # ARN、サービスURLなど
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
# 以下にてポリシーを定義
resource "aws_iam_role_policy_attachment" "app_iam_role_ec2_readonly" {
  # 名前を定義するため、name
  role = aws_iam_role.app_iam_role.name
  # ポリシーのArnはマネジメントコンソール上で既定のポリシーから確認
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_managed" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_ssm_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_iam_role_s3_readonly" {
  role       = aws_iam_role.app_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

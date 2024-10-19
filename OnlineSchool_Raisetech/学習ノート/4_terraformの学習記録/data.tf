# S3のプレフィックスリスト
data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.*.s3"
}
# AMIについて定義
data "aws_ami" "app" {
  # 最近のモノを指定
  most_recent = true
  owners      = ["self", "amazon"]
  # オートスケーリングで追加するインスタンスを定義
  filter {
    name = "name"
    # イメージバージョン管理することを想定。作成していたAMIを指定。
    values = ["tastylog-*-ami"]
  }

  #   #AWS上で定義されているEC2の情報を指定（describe -images　で検索)
  #   filter {
  #     name   = "name"
  #     values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.1-x86_64-gp2"]
  #   }
  #   filter {
  #     name   = "root-device-type"
  #     values = ["ebs"]
  #   }
  #   filter {
  #     name   = "virtualization-type"
  #     values = ["hvm"]
  #   }
}

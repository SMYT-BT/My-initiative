# ----------------------
# Terraform 基本設定
# ----------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  # tfstate上の情報をS3に移動させる
  backend "s3" {
    bucket  = "tasty-log-udemy-20221121"
    key     = "tastylog-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
# ----------------------
# Provider
# ----------------------
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}
# 別リージョン向け ヴァージニア用に追加【任意】複数リージョンに対しての操作
provider "aws" {
  alias = "virginia"
  profile = "terraform"
  region  = "us-east-1"
}
# ----------------------
# 外から定義できる変数
# ----------------------
variable "project" {
  type = string
}
variable "environment" {
  type = string
}
# Rute53のドメイン用
variable "domain" {
  type = string
}

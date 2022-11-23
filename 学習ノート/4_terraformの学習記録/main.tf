#------------------------------コメント
#   Terraform Configure
#------------------------------

# Terraform全体にかかわる設定
terraform {
  # Terraformのバージョン設定
  required_version = ">=0.13"
  # プロバイダーの指定(AWSの指定)
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # 3.0以上
      version = "~>3.0"
    }
  }
  backend "s3" {
    bucket  = "tasty-log-udemy-20221121"
    key     = "tastylog-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
#------------------------------
#  Provider(プロバイダーの設定)
#------------------------------
provider "aws" {
  # .aws配下に作成したProfile-terraformを指定
  profile = "terraform"
  region  = "ap-northeast-1"
}
#------------------------------
# Variables(外から変数を定義する)
#------------------------------
# プロジェクト名を文字列に設定
variable "project" {
  type = string
}
# 環境名を文字列に設定
variable "environment" {
  type = string
}

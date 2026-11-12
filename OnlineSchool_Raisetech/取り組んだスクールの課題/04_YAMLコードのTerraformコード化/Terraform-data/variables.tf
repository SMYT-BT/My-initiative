variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "my_ip_address" {
  description = "SSH接続を許可するグローバルIPv4アドレス（/32付き）"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_address, 0)) && endswith(var.my_ip_address, "/32")
    error_message = "IPv4アドレスを xxx.xxx.xxx.xxx/32 の形式で指定してください。"
  }
}

variable "db_password" {
  description = "RDSマスターパスワード（半角英数字8～41文字）"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8 && length(var.db_password) <= 41 && can(regex("^[a-zA-Z0-9]+$", var.db_password))
    error_message = "パスワードは半角英数字で8～41文字にしてください。"
  }
}

variable "db_engine_version" {
  description = "使用するRDS MySQLエンジンバージョン（例: 8.0.xx）"
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.db_engine_version))
    error_message = "バージョンを x.x.x の形式で指定してください。"
  }
}

variable "alert_email" {
  description = "CloudWatchアラーム通知先メールアドレス"
  type        = string
  validation {
    condition     = can(regex("^[^@ ]+@[^@ ]+\\.[^@ ]+$", var.alert_email))
    error_message = "有効なメールアドレスを指定してください。"
  }
}

variable "ec2_key_name" {
  description = "事前に作成済みのEC2キーペア名"
  type        = string
  default     = "Raisetech_App1020"
}


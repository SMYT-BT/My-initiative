# -----------------------------------
# ACM証明書
# -----------------------------------
# 東京リージョン用
resource "aws_acm_certificate" "tokyo_cert" {
  # ドメイン名。ワイルドカード証明書
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-${var.environment}-willdecared-sslcert"
    Project = var.project
    Env     = var.environment
  }
  lifecycle {
    # リソース操作の詳細制御を指定（true推奨）
    create_before_destroy = true
  }
  # Route53との依存関係を示す
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}
# このファイルが消えるとRoute53も削除されるようにするため記載
resource "aws_route53_record" "route53_acm_dns_resolve" {
  # CNAMEレコードの登録（オブジェクトの形で展開する）
  for_each = {
    for dvo in aws_acm_certificate.tokyo_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  # 既に存在する場合、上書きしてよいか
  allow_overwrite = true
  zone_id         = aws_route53_zone.route53_zone.id
  name            = each.value.name
  type            = each.value.type
  ttl             = 600
  records         = [each.value.record]
}
# DNS検証に向けて、ACM検証本体のリソース
resource "aws_acm_certificate_validation" "cert_valid" {
  certificate_arn         = aws_acm_certificate.tokyo_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_acm_dns_resolve : record.fqdn]
}


# for virgnia region(ヴァージニア向けの証明書)→プロバイダーの上書き
resource "aws_acm_certificate" "virginia_cert" {
  provider = aws.virginia
  # ワイルドカード証明書
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags = {
    Name    = "${var.project}-${var.environment}-willdecared-sslcert"
    Project = var.project
    Env     = var.environment
  }
  lifecycle {
    # リソース操作の詳細制御を指定（true推奨）
    create_before_destroy = true
  }
  # Route53との依存関係を示す
  depends_on = [
    aws_route53_zone.route53_zone
  ]
}

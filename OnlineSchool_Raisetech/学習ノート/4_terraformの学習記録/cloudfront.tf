# -----------------------------------
# Cloudfront cache distribution
# -----------------------------------
resource "aws_cloudfront_distribution" "cf" {
  enabled         = true
  # IPv&通信を有効にするか
  is_ipv6_enabled = true
  comment         = "cache distribution"
  # 初期設定の状態
  price_class = "priceclass_All"
  # ELBのRoute53を指定
  origin {
    # DNSドメイン名
    domain_name = aws_route53_record.route53_record.fqdn
    # オリジンを識別するユニークな名前（※ビヘイビアから参照される）
    origin_id   = aws_lb.alb.name
    # Cloudfrontの宛先を設定（ELB向け）
    custom_origin_config {
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      http_port              = 80
      https_port             = 443
    }
  }

  # 【S3へ転送、キャッシュの実施】
  # オリジンの追加
  origin {
    domain_name = aws_s3_bucket.s3_static_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3_static_bucket.id

    # どのIDで接続していくのか
    s3_origin_config {
      # 属性「.aws_cloudfront_origin_access_identity」
      origin_access_identity = aws_cloudfront_origin_access_identity.aws_cloudfront_origin_access_identity
    }
  }
}

default_cache_behavior {
  # どういったメソッドを受け付けるか
  allowes_methods = ["GET", "HEAD"]
  cached_methods  = ["GET", "HEAD"]
  # 転送する際の設定
  forwarded_values {
    query_string = true
    # Cookieの転送
    cookies {
      forward = "all"
    }
  }
  # 転送先のキャッシュ設定
  target_origin_id       = aws_lb.alb.name
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 0
  max_ttl                = 0
}

# 【S3への転送に向けたビヘイビアを定義】
# 項目については上記に同じく
ordered_cache_behavior {
  # パブリックに対してキャッシュを実施
  path_pattern     = "/public/*"
  allowes_methods  = ["GET", "HEAD"]
  cached_methods   = ["GET", "HEAD"]
  target_origin_id = aws_s3_bucket.s3_static_bucket.id

  forwarded_values {
    query_string = false
    headers      = []
    cookies {
      forward = "name"
    }
  }

  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 86400
  max_ttl                = 31536000
  compress               = true
} # 上記に同じく　終了 

restrictions {
  # アクセス制限
  geo_restriction {
    # 使用しない
    restriction_type = "none"
  }
}
# どのようなドメイン名でアクセスしてくるか
alias = ["dev.${var.domain}"]
# SSLの証明書
viewer_certificate {
  # ヴァージニア向けの証明書を設定★
  acmacm_certificate_arn   = aws_acm_certificate.verginia_cert.arn
  minimum_protocol_version = "TLSv1.2_2019"
  ssl_support_method       = "sni-only"
}


# 【S3へアクセスするためのアイデンティティ】
resource "aws_cloudfront_origin_access_identity" "cf_s3_origin_access_identity" {
  comment = "s3 static buckets access identity"
}

# route53のAレコードを作成
resource "aws_route53_record" "route53_cloudfront" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "dev.${var.domain}"
  type    = "A"
  #CloudFrontに転送する
  alias {
    name                  = aws_cloudfront_distribution.cf.domain_name
    zone_id               = aws_cloudfront_distribution.cf.hosted_zone_id
    evalute_target_health = true
  }
}

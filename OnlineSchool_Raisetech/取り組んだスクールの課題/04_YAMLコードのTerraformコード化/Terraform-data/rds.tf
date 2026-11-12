output "vpc_id" {
  description = "作成したVPC ID"
  value       = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.main.dns_name
}

output "ec2_instance_id" {
  description = "EC2インスタンスID"
  value       = aws_instance.web.id
}

output "rds_endpoint" {
  description = "RDS接続エンドポイント"
  value       = aws_db_instance.main.endpoint
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}


resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.base_domain}"
  validation_method = "DNS" # ドメインの所有権の検証方法
  lifecycle {
    create_before_destroy = true # 再作成の際、新しいものを作成して、削除する。
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
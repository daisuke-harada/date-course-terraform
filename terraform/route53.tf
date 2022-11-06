data "aws_route53_zone" "datecourse" {
  name = var.base_domain
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.datecourse.zone_id
  name    = data.aws_route53_zone.datecourse.name
  type    = "A"
  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  type = each.value.type
  ttl = "300"

  # レコードを追加するドメインのホストゾーンIDを指定
  zone_id = data.aws_route53_zone.datecourse.zone_id
}
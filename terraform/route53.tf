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
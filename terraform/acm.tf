resource "aws_acm_certificate" "cert" {
  domain_name = "*.${var.base_domain}"
  subject_alternative_names = []
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
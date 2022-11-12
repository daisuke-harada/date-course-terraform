resource "aws_lb" "main" {
  name                       = "${var.app_name}-lb"
  load_balancer_type         = "application"
  internal                   = false # falseでインターネット接続という意味
  idle_timeout               = 60
  enable_deletion_protection = false # 削除保護を無効状態にする。
  subnets                    = aws_subnet.public.*.id
  security_groups            = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    target_group_arn = aws_lb_target_group.app.arn
    type             = "forward"
  }

  depends_on = [
    aws_acm_certificate_validation.cert
  ]
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.http.arn

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.app_name}-lb-target-group"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  port        = 80
  protocol    = "HTTP"

  depends_on = [aws_lb.main]
}

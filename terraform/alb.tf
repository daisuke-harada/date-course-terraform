resource "aws_lb" "main" {
  name                       = "${var.app_name}-main-lb"
  load_balancer_type         = "application"
  internal                   = false # falseでインターネット接続という意味
  idle_timeout               = 60
  enable_deletion_protection = false # 削除保護を無効状態にする。
  subnets                    = aws_subnet.public.*.id
  security_groups            = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "main_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.frontend.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "main_https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    target_group_arn = aws_lb_target_group.frontend.arn
    type             = "forward"
  }

  depends_on = [
    aws_acm_certificate_validation.cert
  ]
}

resource "aws_lb_listener_rule" "main_redirect_http_to_https" {
  listener_arn = aws_lb_listener.main_http.arn

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

resource "aws_lb_listener_rule" "main_redirct_backend" {
  listener_arn = aws_lb_listener.main_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "${var.app_name}-frontend-group"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  port        = 80
  protocol    = "HTTP"

  depends_on = [aws_lb.main]
}

resource "aws_lb_target_group" "backend" {
  name        = "${var.app_name}-backend-group"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  port        = 80
  protocol    = "HTTP"

  depends_on = [aws_lb.main]
}

# resource "aws_lb" "backend" {
#   name                       = "${var.app_name}-backend-lb"
#   load_balancer_type         = "application"
#   internal                   = false # falseでインターネット接続という意味
#   idle_timeout               = 60
#   enable_deletion_protection = false # 削除保護を無効状態にする。
#   subnets                    = aws_subnet.public.*.id
#   security_groups            = [aws_security_group.lb.id]
# }

# resource "aws_lb_listener" "backend_https" {
#   load_balancer_arn = aws_lb.backend.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.cert.arn
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   default_action {
#     target_group_arn = aws_lb_target_group.backend.arn
#     type             = "forward"
#   }

#   depends_on = [
#     aws_acm_certificate_validation.cert
#   ]
# }

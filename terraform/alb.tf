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

resource "aws_lb_target_group" "app" {
  name     = "${var.app_name}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  depends_on = [aws_lb.main]
}

resource "aws_security_group" "lb" {
  name   = "${var.app_name}-lb-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

# module "http_sg" {
#   source      = "./security_group"
#   name        = "${var.app_name}-lb-http-sg"
#   vpc_id      = aws_vpc.main.id
#   port        = 80
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "https_sg" {
#   source      = "./security_group"
#   name        = "${var.app_name}-lb-https-sg"
#   vpc_id      = aws_vpc.main.id
#   port        = 443
#   cidr_blocks = ["0.0.0.0/0"]
# }

# module "http_redirect_sg" {
#   source      = "./security_group"
#   name        = "${var.app_name}-lb-http-redirect-sg"
#   vpc_id      = aws_vpc.main.id
#   port        = 80
#   cidr_blocks = ["0.0.0.0/0"]
# }
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

resource "aws_security_group_rule" "egress_lb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group" "frontend" {
  name   = "${var.app_name}-frontend-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_frontend_from_lb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.frontend.id
}

resource "aws_security_group_rule" "egress_frontend" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.frontend.id
}

resource "aws_security_group" "backend" {
  name   = "${var.app_name}-backend-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_backend_from_frontend" {
  type                     = "ingress"
  from_port                = 7777
  to_port                  = 7777
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend.id
  security_group_id        = aws_security_group.backend.id
}

resource "aws_security_group_rule" "egress_backend" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.backend.id
}

# mysqlのrdsのセキュリティグループ
resource "aws_security_group" "mysql" {
  name   = "${var.app_name}-mysql-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_mysql_from_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.backend.id
  security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "egress_mysql" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysql.id
}





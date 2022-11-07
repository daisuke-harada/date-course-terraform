resource "aws_db_subnet_group" "mysql" {
  name       = "${var.app_name}-mysql-group"
  subnet_ids = aws_subnet.database.*.id
}

resource "aws_db_instance" "mysql" {
  identifier             = "${var.app_name}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t3.micro"
  allocated_storage      = 200
  max_allocated_storage  = 1000
  storage_type           = "gp2"
  name                   = var.secrets["db_name"]
  username               = random_string.db_username.result
  password               = random_string.db_password.result
  port                   = 3306
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  skip_final_snapshot    = true
}

resource "random_string" "db_username" {
  length  = 16
  upper   = false
  number  = false
  special = false
}

resource "random_string" "db_password" {
  length           = 16
  special          = true # 特殊文字を使用する
  override_special = "_%"
}
resource "aws_cloudwatch_log_group" "ecs_frontend" {
  name = "${var.app_name}/ecs-frontend"
}

resource "aws_cloudwatch_log_group" "ecs_backend" {
  name = "${var.app_name}/ecs-backend"
}
resource "aws_ecr_repository" "frontend" {
  name = "${var.app_name}-frontend-ecr"
}

resource "aws_ecr_repository" "backend" {
  name = "${var.app_name}-backend-ecr"
}

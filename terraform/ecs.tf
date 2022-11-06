resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.app_name}-frontend"
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = jsonencode([
    {
      name      = "${var.app_name}-frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.ecs_frontend.name
          "awslogs-region" = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name = "${var.app_name}-frontend"
  cluster = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.frontend.id]
    subnets = aws_subnet.application.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name = "${var.app_name}-frontend"
    container_port = 3000
  }
}

# ここからバックエンド
resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.app_name}-backend"
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
  container_definitions    = jsonencode([
    {
      name      = "${var.app_name}-backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 7777
          hostPort      = 7777
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.ecs_backend.name
          "awslogs-region" = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name = "${var.app_name}-backend"
  cluster = aws_ecs_cluster.main.arn
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [aws_security_group.backend.id]
    subnets = aws_subnet.application.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name = "${var.app_name}-backend"
    container_port = 7777
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.app_name}-web"
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions = jsonencode([
    {
      name      = "${var.app_name}-web"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      secrets = [
        {
          "valueFrom" = aws_ssm_parameter.react_app_google_map_api_key.name
          "name"      = "REACT_APP_GOOGLE_MAP_API_KEY"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_frontend.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
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

      secrets = [
        {
          "valueFrom" = aws_ssm_parameter.rails_master_key.name
          "name"      = "RAILS_MASTER_KEY"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_backend.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "web" {
  name                              = "${var.app_name}-web"
  cluster                           = aws_ecs_cluster.main.arn
  task_definition                   = aws_ecs_task_definition.web.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.web.id]
    subnets          = aws_subnet.application.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = aws_ecs_task_definition.web.family
    container_port   = 3000
  }
}

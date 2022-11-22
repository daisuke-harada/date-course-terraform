resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.app_name}-backend"
  cpu                      = 512
  memory                   = 1024
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
  container_definitions = jsonencode([
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

      environment = [
        {
          "value" = "production"
          "name"  = "RAILS_ENV"
        },
        {
          "value" = "https://${aws_route53_record.alb.name}"
          "name"  = "FRONTEND_DOMAIN"
        }
      ]

      secrets = [
        {
          "valueFrom" = aws_ssm_parameter.rails_master_key.name
          "name"      = "RAILS_MASTER_KEY"
        },
        {
          "valueFrom" = aws_ssm_parameter.db_username.name
          "name"      = "MYSQL_USER"
        },
        {
          "valueFrom" = aws_ssm_parameter.db_password.name
          "name"      = "MYSQL_PASSWORD"
        },
        {
          "valueFrom" = aws_ssm_parameter.db_host.name
          "name"      = "MYSQL_HOST"
        },
        {
          "valueFrom" = aws_ssm_parameter.s3.name
          "name"      = "FOG_DIRECTORY"
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

resource "aws_ecs_service" "backend" {
  name                              = "${var.app_name}-backend"
  cluster                           = aws_ecs_cluster.main.arn
  task_definition                   = aws_ecs_task_definition.backend.arn
  desired_count                     = 2 # タスクは常に2つ実行
  launch_type                       = "FARGATE"
  platform_version                  = "1.4.0"
  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.backend.id]
    subnets          = aws_subnet.application.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = aws_ecs_task_definition.backend.family
    container_port   = 7777
  }
}

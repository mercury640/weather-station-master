
resource "aws_ecs_cluster" "weather-station-dev" {
  name = "weather-station-dev"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_service" "weather-station-dev" {
  name            = "weather-station-dev"
  cluster         = aws_ecs_cluster.weather-station-dev.id
  task_definition = aws_ecs_task_definition.weather-station-dev.arn
  desired_count   = 1
  launch_type     = "EC2"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
}

resource "aws_ecs_task_definition" "weather-station-dev" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "weather-station-dev"
      image     = "weather-station-dev"
      memoryReservation = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8888
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "weather-station-staging" {
  name = "weather-station-staging"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_service" "weather-station-staging" {
  name            = "weather-station-staging"
  cluster         = aws_ecs_cluster.weather-station-staging.id
  task_definition = aws_ecs_task_definition.weather-station-staging.arn
  desired_count   = 1
  launch_type     = "EC2"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
}

resource "aws_ecs_task_definition" "weather-station-staging" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "weather-station-staging"
      image     = "weather-station-staging"
      memoryReservation = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8888
        }
      ]
    }
  ])
}

resource "aws_ecs_cluster" "weather-station-prod" {
  name = "weather-station-prod"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_service" "weather-station-prod" {
  name            = "weather-station-prod"
  cluster         = aws_ecs_cluster.weather-station-prod.id
  task_definition = aws_ecs_task_definition.weather-station-prod.arn
  desired_count   = 1
  launch_type     = "EC2"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
}

resource "aws_ecs_task_definition" "weather-station-prod" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "weather-station-prod"
      image     = "weather-station-prod"
      memoryReservation = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8888
        }
      ]
    }
  ])
}
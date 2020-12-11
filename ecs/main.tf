

provider "aws" {
  region = "us-east-1"
}



resource "aws_ecr_repository" "docker-repo" {
  name                 = "my-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  container_definitions = file("my_nginx-def.json")
}

resource "aws_ecs_service" "esc-stage" {
  name = "stage-cluster"
  task_definition = aws_ecs_task_definition.service.id
  launch_type = "FARGATE"
  scheduling_strategy = "DAEMON"
}

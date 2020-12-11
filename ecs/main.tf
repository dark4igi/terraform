

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

resource "aws_ecs_service" "mongo" {
  name = "stage-cluster"
}

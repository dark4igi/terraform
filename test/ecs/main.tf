provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy" "ecr_awslogs_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_deploy_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_deploy_role" {
  name               = "ecs_deploy_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_deploy_role_policy.json
}


resource "aws_iam_role_policy_attachment" "ecs_deploy_role_attach" {
  role       = aws_iam_role.ecs_deploy_role.name
  policy_arn = data.aws_iam_policy.ecr_awslogs_access.arn
}


resource "aws_iam_role" "ecs_exec_role" {
  name               = "ecs_exec_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_deploy_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_attach_1" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = data.aws_iam_policy.ecr_awslogs_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_attach_2" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}




resource "aws_ecr_repository" "my_registry" {
  name                 = "mynginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "terr-ecs"
}

data "template_file" "task_def" {
  template = file("task-def.json")
  vars = {
    var_var = aws_ssm_parameter.foo.value
  }
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  container_definitions = data.template_file.task_def.rendered
  task_role_arn = aws_iam_role.ecs_deploy_role.arn
  execution_role_arn = aws_iam_role.ecs_exec_role.arn
  memory = "1024"
  cpu = "512"
}




resource "aws_ssm_parameter" "foo" {
  name  = "foo"
  type  = "String"
  value = "bar_100500"
}

output "var" {
  value = aws_ssm_parameter.foo.value
}

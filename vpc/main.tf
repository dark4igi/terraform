provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "current" {}

output "az_data" {
  value = data.aws_availability_zones.current
}

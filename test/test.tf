provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "working" {}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  count = length ( data.aws_availability_zones.working.names )
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.working.names [ "${count.index}" ]

  tags = {
    Name = "Main subnet on ${data.aws_availability_zones.working.names [ "${count.index}" ]} az"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}



output "data_aws_availability_zone" {
  value = data.aws_availability_zones.working.names[0]
}

output "data_aws_availability_zone_count" {
  value = length ( data.aws_availability_zones.working.names )
}

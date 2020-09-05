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
    Name = "Main"
    AZ = "${data.aws_availability_zones.working.names [ "${count.index}" ]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "main"
  }
}

data "aws_subnet_ids" "test_subnet_ids" {
  vpc_id = aws_vpc.main.id
}

data "aws_subnet" "main" {
  count = "${length(data.aws_subnet_ids.test_subnet_ids.ids)}"
  id    = "${tolist(data.aws_subnet_ids.test_subnet_ids.ids)[count.index]}"
}

output "tei" {
  value = "${data.aws_subnet_ids.test_subnet_ids.ids}"
}

resource "aws_route_table_association" "a" {
  count = length ( data.aws_availability_zones.working.names )
  subnet_id      = data.aws_subnet.main.*.id [ "${count.index}" ]
  route_table_id = aws_route_table.main.id
}

output "subnet_cidr_blocks" {
  value = "${data.aws_subnet.main.*.id}"
}

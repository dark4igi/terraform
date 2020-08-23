provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "My_Web_Server" {
  ami                    = "ami-02354e95b39ca8dec"
  instance_type          = "t2.medium"
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.My_Web_Server.id]
  user_data              = templatefile("user_data.sh.tpl", {
    f_name = "igi",
    l_name = "moran",
    names = ["Martos", "Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Test"]
  })

  tags = {
    Name = "Web Server"
    Owner = "igi"
  }

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file ("aws-key.pub")
}

resource "aws_security_group" "My_Web_Server" {
  name        = "WS-sg"
  description = "Web server security group"

  dynamic "ingress" {
    for_each = ["80", "443", "22", "8080", "9093"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server sg"
    Owner = "igi"
  }

}

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
    names = ["Vasya", "kolya", "Petya", "John", "Donald", "Masha"]
  })

  tags = {
    Name = "Web Server"
    Owner = "igi"
  }
}

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file ("aws-key.pub")
}

resource "aws_security_group" "My_Web_Server" {
  name        = "WS-sg"
  description = "Web server security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-02354e95b39ca8dec"
  instance_type = "t2.micro"
  key_name      = "aws-key" 

  tags = {
    Name = "HelloWorld"
  }
}

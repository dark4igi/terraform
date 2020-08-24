output "web_server_instance_id" {
  value = aws_instance.My_Web_Server.id
}

output "web_server_public_ip" {
  value = aws_eip.mystatic_ip.public_ip
}

output "web_server_sg_id" {
  value = aws_security_group.My_Web_Server.id
}

output "web_server_sg_arn" {
  value = aws_security_group.My_Web_Server.arn
  description = "sg.arn"
}


output "data_aws_availability_zone" {
  value = data.aws_availability_zones.working
}

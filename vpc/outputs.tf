output "data_aws_availability_zone" {
  value = data.aws_availability_zones.working.names[0]
}

output "data_aws_availability_zone_count" {
  value = length ( data.aws_availability_zones.working.names )
}

#output "subnets" {
#  value = aws_subnet.main.id
#}

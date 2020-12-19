output "data_aws_availability_zone_count" {
  value = length ( data.aws_availability_zones.working.names )
}

output "data_aws_availability_zone_list" {
  value = data.aws_availability_zones.working.names
}

output "subnets" {
  value = [aws_subnet.main.*.id, aws_subnet.main.*.availability_zone]
}

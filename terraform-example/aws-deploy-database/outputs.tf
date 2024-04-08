output "db_instance_endpoint" {
  value       = aws_db_instance.mydatabase.endpoint
}

output "port"{
    value= aws_db_instance.mydatabase.port
}

output "ip_address"{
    value = aws_db_instance.mydatabase.address

}
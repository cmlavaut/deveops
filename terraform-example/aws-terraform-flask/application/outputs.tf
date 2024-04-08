output "Web-link" {
  value = "http://${aws_instance.server.public_ip}"
}

output "IP-privada"{
  value = aws_instance.server.private_ip
}
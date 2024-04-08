provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "aplicacion" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "aplicacion" {
  vpc_id     = aws_vpc.aplicacion.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "aplicacion"
  }
}

resource "aws_internet_gateway" "aplicacion" {
  vpc_id = aws_vpc.aplicacion.id
}

resource "aws_route_table" "aplicacion" {
  vpc_id = aws_vpc.aplicacion.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aplicacion.id
  }
}

resource "aws_route_table_association" "aplicacion" {
  subnet_id      = aws_subnet.aplicacion.id
  route_table_id = aws_route_table.aplicacion.id
}

resource "aws_vpc_dhcp_options" "aplicacion" {
  domain_name_servers  = ["8.8.8.8","8.8.4.4"]  # Servidores DNS que deseas utilizar
}

resource "aws_vpc_dhcp_options_association" "aplicacion" {
  vpc_id          = aws_vpc.aplicacion.id
  dhcp_options_id = aws_vpc_dhcp_options.aplicacion.id
}

resource "aws_instance" "web" {

  ami           =  "ami-0ec3d9efceafb89e0"
  instance_type = var.instance_type
  security_groups = [aws_security_group.app.name]
  count         = var.instance_count
  key_name      =   "app_key"

connection {
    type        = "ssh"
    user        = "admin"  # Replace with the appropriate username for your EC2 instance
    private_key =  file("${local_file.app_key.filename}") # Replace with the path to your private key
    host        = self.public_ip
}

   # File provisioner to copy a file from local to the remote EC2 instance
provisioner "file" {
    source      = "./app.py"  # Replace with the path to your local file
    destination = "/home/admin/app.py"  # Replace with the path on the remote instance
}
   
provisioner "file" {
    source      = "./templates/index.html"  # Replace with the path to your local file
    destination = "/home/admin/templates/index.html"  # Replace with the path on the remote instance
}

provisioner "remote-exec" {
     inline = [
       "echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf > /dev/null"
     ]
}

provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt install -yq build-essential python3-pip rsync",
      "sudo pip install flask",
      "cd /home/admin",
      "sudo python3 app.py",
    ]
}
}



resource "aws_security_group" "app" {
  name        = "app"
  description = "Allow SSH and HTTP"
  vpc_id = aws_vpc.aplicacion.id


  ingress {
    from_port   = 80
    to_port     = 80
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
}

resource "aws_key_pair" "app_key"{
    key_name= "app_key"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "app_key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "appkey.pem"
}
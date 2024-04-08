provider "aws" {
  region = var.region  # Replace with your own region
}

resource "aws_instance" "server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name      = "flask1_key"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key =  file("${local_file.flask1_key.filename}") # Replace with the path to your private key
    host        = self.public_ip
   }

   # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "../flaskapp/app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
   }
   
  provisioner "file" {
    source      = "../flaskapp/templates/index.html"  # Replace with the path to your local file
    destination = "/home/ubuntu/templates/index.html"  # Replace with the path on the remote instance
   }

   provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py",
    ]
   }
}


resource "aws_key_pair" "flask1_key"{
    key_name= "flask1_key"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "flask1_key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "flask1key.pem"
}
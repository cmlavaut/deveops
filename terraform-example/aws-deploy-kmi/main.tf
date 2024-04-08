provider "aws" {
    region = var.region_name
}

resource "aws_instance" "web" {
    ami = "ami-0b9932f4918a00c4f"
    instance_type = var.instance_type
    security_groups = [aws_security_group.ssh_http.name]
    user_data              = file("template/user_data.sh")
    count         = var.instance_count
    key_name = "kmi_key"

}

resource "aws_security_group" "ssh_http"{
    name = "ssh_http"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
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

resource "aws_key_pair" "kmi_key"{
    key_name= "kmi_key"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "kmi_key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "kmikey.pem"
}
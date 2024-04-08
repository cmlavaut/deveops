provider "aws"{
    region = var.region
}


resource "aws_db_instance" "mydatabase"{
  identifier_prefix    ="terraform-example" 
  engine               = "mysql"
  allocated_storage    = 20
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = var.username
  password             = var.password
  db_name              = var.database_name
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  true #que la database se puede acceder desde internet 
}


resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
variable "region"{
    default = "us-east-1"
}

variable "instance_type" {
    description = "Value for Instance type"
    default = "t2.micro"
}

variable "ami_id" {
    description = "Value for ami-id"
    default  = "ami-053b0d53c279acc90"
}

variable "sg-name" {
    description = "Name for Security group"
    default = "test-app-sg"
}

variable "vpc-cidr" {
    description = "Value for cidr"
    default = "10.0.0.0/16"
}

variable "subnet_az" {
    description = "Value for Availabilty zone of subnet"
    default = "us-east-1a"
}


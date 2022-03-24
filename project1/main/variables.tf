#----root/variables.tf----
variable "aws_region" {
  type = string
  default = "us-west-2"
}

variable "access_ip_myid" {
  default = "0.0.0.0/0"
}

variable "access_ip_all" {
  default = "0.0.0.0/0"
}

variable "access_ip_bastion" {
  default = "0.0.0.0/0"
}

variable "access_ip_alb" {
  default = "0.0.0.0/0"
}

variable "private_instance_type" {
  type = string
  default = "t2.micro"
}

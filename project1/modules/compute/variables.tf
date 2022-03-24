#----compute/variables.tf---

#-----private compute---
variable "private_instance_count" {}
variable "private_instance_type" {}
variable "private_sg" {}
variable "private_subnets" {}
variable "private_volume_size" {}
#------public compute------
variable "public_instance_count" {}
variable "public_instance_type" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "public_volume_size" {}
variable "user_data_path" {}
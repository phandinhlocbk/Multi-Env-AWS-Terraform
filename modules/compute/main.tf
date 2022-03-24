#----compute/main.tf----

#----private compute-----
resource "random_id" "test_private_node_id" {
    byte_length = 2
    count = var.private_instance_count
}

resource "aws_instance" "private_node" {
  count = var.private_instance_count
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.private_instance_type

  tags = {
    Name = "mtc-node-${random_id.test_private_node_id[count.index].dec}"
  }
  user_data = file(var.user_data_path)
  vpc_security_group_ids = [var.private_sg]
  subnet_id = var.private_subnets[count.index]
  root_block_device {
      volume_size = var.private_volume_size
  }
  
}

#------windown type public subnet -----

resource "random_id" "test_public_node_id" {
    byte_length = 2
    count = var.public_instance_count
}

resource "aws_instance" "public_node" {
  count = var.public_instance_count
  ami           = "ami-0f9a92942448ac56f"
  instance_type = var.public_instance_type

  tags = {
    Name = "mtc-node-${random_id.test_public_node_id[count.index].dec}"
  }
 
  vpc_security_group_ids = [var.public_sg]
  subnet_id = var.public_subnets[count.index]
  root_block_device {
      volume_size = var.public_volume_size
  }
  
}
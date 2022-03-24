#------interfacing/main.tf-----
resource "aws_eip" "test_nat_eip" {
 vpc = true

  tags = {
    Name = "test-nat-eip"
  }
}


resource "aws_nat_gateway" "test_nat_gw" {
  #count = var.public_sn_count
  subnet_id     = var.public_subnet_id[1]
  allocation_id = aws_eip.test_nat_eip.id
  tags = {
    Name = "test_nat_gw"
  }
}

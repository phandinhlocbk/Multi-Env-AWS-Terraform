#------networking/main.tf----

 resource "random_integer" "random" {
     min = 1
     max = 100
 }
 
 data "aws_availability_zones" "avaiable" {}
 
 resource "random_shuffle" "test_az" {
     input = data.aws_availability_zones.avaiable.names
     result_count = 20
 }
 
 resource "aws_vpc" "test_vpc" {
     cidr_block = var.test_vpc_cidr_block
     enable_dns_hostnames = true
     enable_dns_support = true
     
     tags = {
         Name = "test_vpc"
     }
 }
 
 #------public subnet
 resource "aws_subnet" "test_public_subnet" {
     count = var.public_sn_count
     vpc_id = aws_vpc.test_vpc.id
     cidr_block = var.test_public_subnet_cidr[count.index]
     availability_zone_id = random_shuffle.test_az.result[count.index]
     map_public_ip_on_launch = true
     
     tags = {
         Name = "test_public_subnet_${count.index + 1}"
     }
 }
 
 #------private subnet
 resource "aws_subnet" "test_private_subnet" {
     count = var.private_sn_count
     vpc_id = aws_vpc.test_vpc.id
     cidr_block = var.test_private_subnet_cidr[count.index]
     availability_zone_id = random_shuffle.test_az.result[count.index]
     map_public_ip_on_launch = false
     
     tags = {
         Name = "test_private_subnet_${count.index + 1}"
     }
 }
 
 #-----internetgateway
 resource "aws_internet_gateway" "test_gw" {
     vpc_id = aws_vpc.test_vpc.id
     
     tags = {
      Name = "test_igw"
     }
 }
 
 #-----public route table 
 resource "aws_route_table" "test_public_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags =  {
   Name = "public_rt"
  }
}

resource "aws_route" "test_public_rout" {
  route_table_id            = aws_route_table.test_public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.test_gw.id
}

resource "aws_route_table_association" "public_route_assoc" {
  count = var.public_sn_count
  subnet_id      = aws_subnet.test_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.test_public_rt.id
}

#-------------private route table

 resource "aws_route_table" "test_private_rt" {
  vpc_id = aws_vpc.test_vpc.id
  tags =  {
   Name = "private_rt"
  }
}

resource "aws_route" "test_private_out" {
  route_table_id            = aws_route_table.test_private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = var.test_nat_gateway_id # Nat #aws_internet_gateway.test_gw.id 
}

resource "aws_route_table_association" "private_route_assoc" {
  count = var.private_sn_count
  subnet_id      = aws_subnet.test_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.test_private_rt.id
}

#-----------Sercurity group
resource "aws_security_group" "test_sg" {
  for_each = var.security_groups
  name = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.test_vpc.id
  
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
#--------


 
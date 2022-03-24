#---networking/outputs.tf----

output "public_sg" {
    value = aws_security_group.test_sg["public"].id
}

output "public_subnets" {
    value = aws_subnet.test_public_subnet.*.id
}

output "vpc_id" {
    value = aws_vpc.test_vpc.id
}

output "private_sg" {
    value = aws_security_group.test_sg["private"].id
}

output "private_subnets" {
    value = aws_subnet.test_private_subnet.*.id
    }
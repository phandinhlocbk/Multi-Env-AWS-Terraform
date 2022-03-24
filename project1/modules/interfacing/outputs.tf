#----interfacing/outputs.tf---

output "test_nat_gateway" {
    value = aws_nat_gateway.test_nat_gw.id
}
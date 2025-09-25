output "eip-nat-gw-1" {
  value = aws_eip.eip_nat_gw_1.public_ip
}
output "eip-nat-gw-2" {
  value = aws_eip.eip_nat_gw_2.public_ip
}
output "nat-gw-1_id" {
  value = aws_nat_gateway.nat_gw_1.id
}
output "nat-gw-2_id" {
  value = aws_nat_gateway.nat_gw_2.id
}

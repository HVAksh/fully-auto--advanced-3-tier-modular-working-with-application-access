output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_1_id" {
  value = aws_subnet.pub_sub_1.id
}
output "pub_sub_2_id" {
  value = aws_subnet.pub_sub_2.id
}
output "web_sub_1_id" {
  value = aws_subnet.web_sub_1.id
}
output "web_sub_2_id" {
  value = aws_subnet.web_sub_2.id
}
output "app_sub_1_id" {
  value = aws_subnet.app_sub_1.id
}
output "app_sub_2_id" {
  value = aws_subnet.app_sub_2.id
}
output "db_sub_1_id" {
  value = aws_subnet.db_sub_1.id
}
output "db_sub_2_id" {
  value = aws_subnet.db_sub_2.id
}
output "igw_id" {
  value = aws_internet_gateway.igw.id
}



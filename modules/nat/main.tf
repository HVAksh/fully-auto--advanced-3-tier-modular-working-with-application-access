#✅ Create EIP for NAT in zone1
resource "aws_eip" "eip_nat_gw_1" {
  domain = "vpc"
}

#✅ Create EIP for NAT in zone2
resource "aws_eip" "eip_nat_gw_2" {
  domain = "vpc"
}



#✅ Create Public NAT-GW1 in zone1
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.eip_nat_gw_1.id
  subnet_id     = var.pub_sub_1_id

  tags = {
    Name = "project1-pub-nat-gw-1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

#✅ Create Public NAT-GW in zone2
resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.eip_nat_gw_2.id
  subnet_id     = var.pub_sub_2_id

  tags = {
    Name = "project1-pub-nat-gw-2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}


data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.env}-${var.region}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.region}-igw"
  }
}
###########################################################
############          PUBLIC SUBNET          ##############
###########################################################
resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_sub_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env}-${var.region}-pub-sub-1"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub_sub_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.env}-${var.region}-pub-sub-2"
  }
}

###########################################################
##############          WEB SUBNET          ###############
###########################################################
resource "aws_subnet" "web_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.web_sub_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env}-${var.region}-web-sub-1"
  }
}

resource "aws_subnet" "web_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.web_sub_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.env}-${var.region}-web-sub-2"
  }
}

###########################################################
##############          APP SUBNET          ###############
###########################################################
resource "aws_subnet" "app_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.app_sub_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env}-${var.region}-app-sub-1"
  }
}

resource "aws_subnet" "app_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.app_sub_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.env}-${var.region}-app-sub-2"
  }
}

###########################################################
##############          DB SUBNET          ################
###########################################################
resource "aws_subnet" "db_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.db_sub_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env}-${var.region}-db-sub-1"
  }
}

resource "aws_subnet" "db_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.db_sub_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.env}-${var.region}-db-sub-2"
  }
}

#########################################################################################################
#✅ Create Public Route table and public route
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }

}

# Public route table association to public subnet pub-sub-z1
resource "aws_route_table_association" "pub-sub-z1" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.pub_rt.id
}

# Public route table association to public subnet pub-sub-z2
resource "aws_route_table_association" "pub-sub-z2" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.pub_rt.id
}
#########################################################################################################
#✅ Create private Route table for Web Z1
resource "aws_route_table" "web_pri_rt_z1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_1_id
  }

  tags = {
    Name = "pri-rt-app"
  }
}


resource "aws_route_table_association" "web_pri_rt_assoc_z1" {
  subnet_id      = aws_subnet.web_sub_1.id
  route_table_id = aws_route_table.web_pri_rt_z1.id
}



#########################################################################################################
#✅ Create private Route table for Web Z2
resource "aws_route_table" "web_pri_rt_z2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_2_id
  }

  tags = {
    Name = "pri-rt-app"
  }
}


resource "aws_route_table_association" "web_pri_rt_assoc_z2" {
  subnet_id      = aws_subnet.web_sub_2.id
  route_table_id = aws_route_table.web_pri_rt_z2.id
}

#########################################################################################################
#✅ Create private Route table for APP Z1
resource "aws_route_table" "app_pri_rt_z1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_1_id
  }

  tags = {
    Name = "pri-rt-app"
  }
}


resource "aws_route_table_association" "app_pri_rt_assoc_z1" {
  subnet_id      = aws_subnet.app_sub_1.id
  route_table_id = aws_route_table.app_pri_rt_z1.id
}


#########################################################################################################
#✅ Create private Route table for APP Z2
resource "aws_route_table" "app_pri_rt_z2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_2_id
  }

  tags = {
    Name = "pri-rt-app"
  }
}


resource "aws_route_table_association" "app_pri_rt_assoc_z2" {
  subnet_id      = aws_subnet.app_sub_2.id
  route_table_id = aws_route_table.app_pri_rt_z2.id
}

# #########################################################################################################
#✅ Create private Route table for DB Z1
resource "aws_route_table" "db_pri_rt_db_z1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_1_id
  }

  tags = {
    Name = "pri-rt-db"
  }

}

# Private route table association to db subnet in both zone
resource "aws_route_table_association" "db_pri_rt_assoc_z1" {
  subnet_id      = aws_subnet.db_sub_1.id
  route_table_id = aws_route_table.db_pri_rt_db_z1.id

}

############################################################################################################
#✅ Create private Route table for DB Z2
resource "aws_route_table" "db_pri_rt_db_z2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_2_id
  }

  tags = {
    Name = "pri_rt_db_z2"
  }

}

# Private route table association to db subnet in both zone
resource "aws_route_table_association" "db_pri_rt_assoc_z2" {
  subnet_id      = aws_subnet.db_sub_2.id
  route_table_id = aws_route_table.db_pri_rt_db_z2.id

}
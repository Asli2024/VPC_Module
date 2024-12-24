resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "main_public_rt"
  }
}

resource "aws_subnet" "public" {
  count                   = var.number_of_public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true
  tags = {
    Name = "main_public_subnet_${count.index}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.number_of_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    Name = "main_private_subnet_${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_private_rt"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = var.number_of_private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_nat_gateway" "nat" {
  count         = var.number_of_natgateways
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "main_nat_${count.index}"
  }
}

resource "aws_eip" "nat" {
  count = var.number_elastic_ips
  tags = {
    Name = "main_nat_eip_${count.index}"
  }
}

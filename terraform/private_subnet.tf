resource "aws_subnet" "frontend" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)

  tags = {
    Name ="${var.app_name}-frontend-subnet-${count.index}"
  }
}

resource "aws_subnet" "backend" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 20 + count.index)

  tags = {
    Name ="${var.app_name}-backend-subnet-${10 + count.index}"
  }
}
resource "aws_subnet" "frontend" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)

  tags = {
    Name ="${var.app_name}-frontend-subnet-${count.index}"
  }
}

resource "aws_subnet" "backend" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 10 + count.index)

  tags = {
    Name ="${var.app_name}-backend-subnet-${10 + count.index}"
  }
}
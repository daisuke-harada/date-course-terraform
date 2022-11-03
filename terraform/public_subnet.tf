resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"

  tags = {
    Name ="${var.app_name}-public-subnet"
  }
}
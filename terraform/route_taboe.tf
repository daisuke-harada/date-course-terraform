resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "インターネットゲートウェイルートテーブル"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id

  gateway_id = aws_internet_gateway.main.id

  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "frontend" {
  count = 2
  subnet_id = element(aws_subnet.frontend.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "backend" {
  count = 2
  subnet_id = element(aws_subnet.backend.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

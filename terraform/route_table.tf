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

# パブリックサブネットとのルートアソシエーション を作成
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  count                  = 2
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.application.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

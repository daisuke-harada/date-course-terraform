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
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

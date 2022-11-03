# IPアドレスを固定させる。
resource "aws_eip" "nat_gateway" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.main] # インターネットゲートウェイが作成されてから作成されるようにする。
}

resource "aws_nat_gateway" "main" {
  count         = var.az_count
  allocation_id = element(aws_eip.nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on = [aws_internet_gateway.main] # インターネットゲートウェイが作成されてから作成されるようにする。
}
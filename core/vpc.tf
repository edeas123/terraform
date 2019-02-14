resource "aws_vpc" "mybytesni" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "primary"
  }
}

resource "aws_subnet" "mybytesni-private" {
  vpc_id =  "${aws_vpc.mybytesni.id}"
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "mybytesni-public" {
  vpc_id =  "${aws_vpc.mybytesni.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}

resource "aws_internet_gateway" "mybytesni" {
  vpc_id = "${aws_vpc.mybytesni.id}"

  tags = {
    Name = "primary"
  }
}

data "aws_route_table" "default" {
  vpc_id = "${aws_vpc.mybytesni.id}"
  filter = {
    name = "association.main"
    values = ["true"]
  }
}

resource "aws_route_table_association" "primary-private" {
  subnet_id = "${aws_subnet.mybytesni-private.id}"
  route_table_id = "${data.aws_route_table.default.id}"
}

resource "aws_route_table" "primary" {
  vpc_id = "${aws_vpc.mybytesni.id}"

  tags = {
    Name = "primary"
  }
}

resource "aws_route" "internet" {
  route_table_id = "${aws_route_table.primary.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.mybytesni.id}"
}

resource "aws_route_table_association" "primary-public" {
  subnet_id = "${aws_subnet.mybytesni-public.id}"
  route_table_id = "${aws_route_table.primary.id}"
}

resource "aws_default_vpc" "default" {
  tags {
    Name = "default VPC"
  }
}

output "default-vpc-id" {
  value = "${aws_default_vpc.default.id}"
}

output "mybytesni-vpc-id" {
  value = "${aws_vpc.mybytesni.id}"
}

output "mybytesni-private-subnet-id" {
  value = "${aws_subnet.mybytesni-private.id}"
}

output "mybytesni-public-subnet-id" {
  value = "${aws_subnet.mybytesni-public.id}"
}
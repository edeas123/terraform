resource "aws_default_vpc" "default" {
  tags {
    Name = "default VPC"
  }
}

output "default-vpc-id" {
  value = "${aws_default_vpc.default.id}"
}
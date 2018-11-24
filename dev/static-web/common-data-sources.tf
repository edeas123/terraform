# TODO: use todo to get the vpc id
# TODO: modify for cases of multiple security group
# list of the ids of all subnets in the vpc
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"
}

# ids of all subnets in the vpc
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}
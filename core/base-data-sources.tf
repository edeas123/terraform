# create a policy document for the role
# instead of using a policy document, it can used directly in
# the role using terraform heredoc syntax
# rename to common-data-sources
# TODO: this shouldnt be here
data "aws_iam_policy_document" "s3access-role-policy" {
	statement {
		actions = ["sts:AssumeRole"]
		principals {
			type 		= "Service"
			identifiers = ["ec2.amazonaws.com"]
		}
	}
}

# TODO: use todo to get the vpc id
# TODO: modify for cases of multiple security group
# list of the ids of all subnets in the vpc
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"
}

# create an iam user for circleci
resource "aws_iam_user" "circleci" {
	name = "circleci"
}

# create the access key for the iam user
# TODO: Attempt to use pgp keys another time. This attempt has taken too long to figure out
resource "aws_iam_access_key" "circleci-access-key" {
	user = "${aws_iam_user.circleci.name}"
}

# attach a managed policy to the created role, for full access to ecr
resource "aws_iam_user_policy_attachment" "circleci-ecr-policy-attachment" {
  user       = "${aws_iam_user.circleci.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

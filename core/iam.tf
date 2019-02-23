
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

# create a policy document for the role
# instead of using a policy document, it can used directly in
# the role using terraform heredoc syntax
data "aws_iam_policy_document" "ec2-access-policy" {
	statement {
		actions = ["sts:AssumeRole"]
		principals {
			type 		= "Service"
			identifiers = ["ec2.amazonaws.com"]
		}
	}
}

# set an aws iam role with accompanying policy for ec2 
resource "aws_iam_role" "s3access-role" {
	name = "s3access-role"
	description = "Allows EC2 instances to call AWS S3 service on your behalf."
 	assume_role_policy = "${data.aws_iam_policy_document.ec2-access-policy.json}"
}

# attach a managed policy to the created role, for full access to s3
resource "aws_iam_policy_attachment" "s3access-policy-attachment" {
  name       = "s3access-policy-attachment"
  roles      = ["${aws_iam_role.s3access-role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# enable the ec2 instance to use that role and manually test
# since internal aws uses the same name for the role and profile
# its best to do the same
resource "aws_iam_instance_profile" "s3access-role" {
	name = "s3access-role"
	role = "${aws_iam_role.s3access-role.name}"
}

output "s3access-role-iam-instance-profile-name" {
  value = "${aws_iam_instance_profile.s3access-role.name}"
}

# set an aws iam role with accompanying policy for ec2 
resource "aws_iam_role" "jenkins-role" {
	name = "jenkins-role"
	description = "Allows jenkins EC2 instances to call AWS services on your behalf."
 	assume_role_policy = "${data.aws_iam_policy_document.ec2-access-policy.json}"
}

# attach a managed policy to the created role, for full access to s3
resource "aws_iam_role_policy_attachment" "jenkins-policy-attachment" {
  role      = "${aws_iam_role.jenkins-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "jenkins-role" {
	name = "jenkins-role"
	role = "${aws_iam_role.jenkins-role.name}"
}

output "jenkins-role-iam-instance-profile-name" {
  value = "${aws_iam_instance_profile.jenkins-role.name}"
}

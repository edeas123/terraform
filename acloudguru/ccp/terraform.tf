# configure the default cloud provider
provider "aws" {
  	version 	= "1.42.0"
  	region		= "${var.region}"
}

# use this provider configuration when required
# mainly because of out-of-region s3 bucket i created
# did not work
# what worked was to temporarily change the main profile region
provider "aws" {
	alias		= "asia"
  	version 	= "1.42.0"
  	region 		= "ap-southeast-2"
}

# create the ec2 instance with an ebs volume
# use the deployer key
# NOTE: Changing user_data forces a new instance, hence not recommended for configuration
# management that may change
# use ansible, or other CM tools
resource "aws_instance" "web-server-1" {
	ami           = "ami-0ff8a91507f77f867"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${aws_iam_instance_profile.s3access-role.name}"
	availability_zone = "us-east-1a"

	tags = {
		Name = "web-server-1" 
	}
	user_data = "${file("make-web-server.sh")}"
	depends_on = [
		"aws_s3_bucket.a-static-website-bucket"
	]
}

# create another ec2 instance with an ebs volume
# use the deployer key
resource "aws_instance" "web-server-2" {
	ami           = "ami-0ff8a91507f77f867"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${aws_iam_instance_profile.s3access-role.name}"
	availability_zone = "us-east-1b"

	tags = {
		Name = "web-server-2" 
	}
	user_data = "${file("make-web-server.sh")}"
	depends_on = [
		"aws_s3_bucket.a-static-website-bucket"
	]
}

# create an s3 bucket in a different region
resource "aws_s3_bucket" "an-empty-bucket" {
	bucket = "an-empty-bucket"
	provider = "aws.asia"
	force_destroy = true
	region = "ap-southeast-2"
	acl = "private"
}

# create a another s3 bucket just to keep your domain name
resource "aws_s3_bucket" "mybytesni" {
	bucket = "mybytesni"
	force_destroy = true
	acl = "private"
}

# create another s3 bucket to host a static website
resource "aws_s3_bucket" "a-static-website-bucket" {
	bucket = "a-static-website-bucket"
	acl = "private"
	force_destroy = true
	website {
		index_document = "index.html"
		error_document = "error.html"
	}
	policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
		"Sid": "PublicReadGetObject",
		"Effect": "Allow",
		"Principal": "*",
		"Action": "s3:GetObject",
		"Resource": "arn:aws:s3:::a-static-website-bucket/*"
		}
	]
}
POLICY
}

# upload the index html file to the s3 bucket
resource "aws_s3_bucket_object" "index-file" {
	bucket = "${aws_s3_bucket.a-static-website-bucket.bucket}"
	key = "index.html"
	source = "index.html"
	content_type = "text/html"
}

# upload the error html file to the s3 bucket
resource "aws_s3_bucket_object" "error-file" {
	bucket = "${aws_s3_bucket.a-static-website-bucket.bucket}"
	key = "error.html"
	source = "error.html"
	content_type = "text/html"
}

# create a policy document for the role
# instead of using a policy document, it can used directly in
# the role using terraform heredoc syntax
data "aws_iam_policy_document" "s3access-role-policy" {
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
 	assume_role_policy = "${data.aws_iam_policy_document.s3access-role-policy.json}"
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
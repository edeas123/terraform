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
# using the deployer key
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

# create an application load balancer
resource "aws_alb" "web-server-alb" {
	name = "web-server-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"

	subnets = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
}

# create an application load balancer listener 
resource "aws_alb_listener" "web-server-alb-listener" {
	load_balancer_arn = "${aws_alb.web-server-alb.arn}"
	port = 80
	protocol = "HTTP"

	default_action {
    	type             = "forward"
    	target_group_arn = "${aws_alb_target_group.web-server-target-group.arn}"
  	}
}

# create the application load balancer target group
resource "aws_alb_target_group" "web-server-target-group" {
	name = "web-server-target-group"
	port = 80
	protocol = "HTTP"
	vpc_id = "vpc-6f3d7608"
}

# attach the two webserver instances to the target group
resource "aws_alb_target_group_attachment" "web-server-1-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.web-server-target-group.arn}"
  target_id        = "${aws_instance.web-server-1.id}"
  port             = 80
}
resource "aws_alb_target_group_attachment" "web-server-2-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.web-server-target-group.arn}"
  target_id        = "${aws_instance.web-server-2.id}"
  port             = 80
}

# create the ec2 instance with an ebs volume
# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "web-server-1" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${aws_iam_instance_profile.s3access-role.name}"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.web-sg-id}"
	]
	tags = {
		Name = "web-server-1" 
	}
	user_data = "${file("make-web-server.sh")}"
}

# create another ec2 instance with an ebs volume
# using the deployer key
resource "aws_instance" "web-server-2" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${aws_iam_instance_profile.s3access-role.name}"
	availability_zone = "${data.aws_availability_zones.zones.names[1]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.web-sg-id}"
	]
	tags = {
		Name = "web-server-2" 
	}
	user_data = "${file("make-web-server.sh")}"
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
# https://www.terraform.io/docs/providers/aws/r/lb.html
resource "aws_alb" "web-server-alb" {
	name = "web-server-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"

	subnets = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
	security_groups = [
		"${data.terraform_remote_state.core.web-sg-id}"
	]
}

# create an application load balancer listener 
# https://www.terraform.io/docs/providers/aws/r/lb_listener.html
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
# https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
resource "aws_alb_target_group" "web-server-target-group" {
	name = "web-server-target-group"
	port = 80
	protocol = "HTTP"
	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}

# attach the two webserver instances to the target group
# https://www.terraform.io/docs/providers/aws/r/lb_target_group_attachment.html
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

# output the instances ip addresses
output "webserver-1-ip" {
  value = "${aws_instance.web-server-1.public_ip}"
}
output "webserver-2-ip" {
  value = "${aws_instance.web-server-2.public_ip}"
}

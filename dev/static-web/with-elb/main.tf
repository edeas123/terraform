# create the ec2 instance with an ebs volume
resource "aws_instance" "web-server-1" {
	ami	= "${data.aws_ami.ubuntu-ami.id}"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${data.terraform_remote_state.core.s3access-role-iam-instance-profile-name}"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
    "${data.terraform_remote_state.core.ssh-sg-id}",
		"${data.terraform_remote_state.core.web-sg-id}"
	]
	tags = {
		Name = "web-server-1" 
	}
}

# create another ec2 instance with an ebs volume
# using the deployer key
resource "aws_instance" "web-server-2" {
	ami	= "${data.aws_ami.ubuntu-ami.id}"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	iam_instance_profile = "${data.terraform_remote_state.core.s3access-role-iam-instance-profile-name}"
	availability_zone = "${data.aws_availability_zones.zones.names[1]}"
	vpc_security_group_ids = [
    "${data.terraform_remote_state.core.ssh-sg-id}",
		"${data.terraform_remote_state.core.web-sg-id}"
	]
	tags = {
		Name = "web-server-2" 
	}
}



# create an application load balancer
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

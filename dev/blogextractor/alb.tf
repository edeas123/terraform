# create an application load balancer
resource "aws_alb" "blogextractor-alb" {
	name = "blogextractor-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"
	subnets = ["${data.terraform_remote_state.core.aws-subnet-ids}"]
	security_groups = [
    "${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
}

# create an application load balancer listener 
resource "aws_alb_listener" "blogextractor-alb-listener" {
	load_balancer_arn = "${aws_alb.blogextractor-alb.arn}"
	port = 80
	protocol = "HTTP"

	default_action {
    	type             = "forward"
    	target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  	}
}

# create the application load balancer target group
resource "aws_alb_target_group" "blogextractor-target-group" {
	name = "blogextractor-target-group"
	port = 80
	protocol = "HTTP"
	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}

# attach the two blogextractor server instances to the target group
resource "aws_alb_target_group_attachment" "blogextractor-target-group-instances" {
  target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  target_id        = "${aws_instance.blogextractor.*.id[count.index]}"
  port             = 80
	count            = 2
}
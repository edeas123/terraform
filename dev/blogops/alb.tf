# create an application load balancer
resource "aws_alb" "blogextractor-alb" {
	name = "blogextractor-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"

	subnets = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
	security_groups = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
}

# create an application load balancer listener 
resource "aws_alb_listener" "blogextractor-alb-listener" {
	load_balancer_arn = "${aws_alb.blogextractor-alb.arn}"
	port = 5000
	protocol = "HTTP"

	default_action {
    	type             = "forward"
    	target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  	}
}

# create the application load balancer target group
resource "aws_alb_target_group" "blogextractor-target-group" {
	name = "blogextractor-target-group"
	port = 5000
	protocol = "HTTP"
	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}

# attach the two webserver instances to the target group
resource "aws_alb_target_group_attachment" "blogextractor-1-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  target_id        = "${aws_instance.blogextractor-1.id}"
  port             = 5000
}
resource "aws_alb_target_group_attachment" "blogextractor-2-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  target_id        = "${aws_instance.blogextractor-2.id}"
  port             = 5000
}
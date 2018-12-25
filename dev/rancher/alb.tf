resource "aws_alb" "rancher-ctl-host-alb" {
	name = "rancher-ctl-host-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"

	subnets = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
	security_groups = [
		"${aws_security_group.rancher-ctl-host-alb-sg.id}"
	]
}

# create an application load balancer listener 
resource "aws_alb_listener" "rancher-ctl-host-alb-listener" {
	load_balancer_arn = "${aws_alb.rancher-ctl-host-alb.arn}"
	port = 80
	protocol = "HTTP"

	default_action {
    	type             = "forward"
    	target_group_arn = "${aws_alb_target_group.rancher-ctl-host-target-group.arn}"
  	}
}

# create the application load balancer target group
resource "aws_alb_target_group" "rancher-ctl-host-target-group" {
	name = "rancher-ctl-host-target-group"
	port = 8080
	protocol = "HTTP"
	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}

# attach the three hosts to the target group
resource "aws_alb_target_group_attachment" "rancher-ctl-host-target-group-instances" {
  target_group_arn = "${aws_alb_target_group.rancher-ctl-host-target-group.arn}"
  target_id        = "${aws_instance.rancher-ctl-host.*.id[count.index]}"
  port             = 8080
  count            = 3
}

resource "aws_route53_record" "rancher-ctl-cname-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "rancherctl.${data.aws_route53_zone.primary-domain.name}"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_alb.rancher-ctl-host-alb.dns_name}"]
}
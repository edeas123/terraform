resource "aws_spot_instance_request" "rancher-ctl-host" {
	ami	= "${data.aws_ami.ubuntu-ami.id}"
	instance_type = "m4.large"
	spot_type = "one-time"
	key_name = "deployer"
  availability_zone = "${data.aws_availability_zones.zones.names[count.index]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.rancher-ctl-host-sg-id}",
		"${data.terraform_remote_state.core.ssh-sg-id}"
	]
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "${format("rancher-ctl-host%d", count.index)}"
	}
  count = 3
}

resource "aws_route53_record" "rancher-ctl-host-cname-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "${format("rancherctl%d", count.index)}.${data.aws_route53_zone.primary-domain.name}"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_spot_instance_request.rancher-ctl-host.*.public_dns[count.index]}"]
  count   = 3
}

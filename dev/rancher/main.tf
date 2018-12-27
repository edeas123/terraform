resource "aws_instance" "rancher-ctl-host" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${aws_security_group.rancher-ctl-host-sg.id}",
		"${aws_security_group.ssh-sg.id}"
	]
	tags {
		Name = "${format("rancher-ctl-host%d", count.index)}"
	}
  count = 3
}

resource "aws_instance" "rancher-container-host" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${aws_security_group.rancher-container-host-sg.id}",
		"${aws_security_group.ssh-sg.id}"
	]
	tags {
		Name = "${format("rancher-container-host%d", count.index)}"
	}
  count = 2
}

resource "aws_route53_record" "rancher-ctl-host-cname-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "${format("rancherctl%d", count.index)}.${data.aws_route53_zone.primary-domain.name}"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_instance.rancher-ctl-host.*.public_dns[count.index]}"]
  count   = 3
}

output "rancher-ctl-host-ips" {
	value = "${aws_instance.rancher-ctl-host.*.public_ip}"
}
output "rancher-container-host-ips" {
	value = "${aws_instance.rancher-container-host.*.public_ip}"
}
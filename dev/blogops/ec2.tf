resource "aws_instance" "blogextractor" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}",
		"${data.terraform_remote_state.core.ssh-sg-id}"
	]
	tags {
		Name = "${format("blogextractor%d", count.index)}"
	}
	count = 2
}

resource "aws_route53_record" "blogextractor-cname-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "${format("blogextractor%d", count.index)}.${data.aws_route53_zone.primary-domain.name}"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_instance.blogextractor.*.public_dns[count.index]}"]
  count   = 2
}
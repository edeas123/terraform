# TODO: two spot instances, 1 ASG with 1 additional instance, 1lb

resource "aws_route53_record" "blogextractor-alias-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "extractors.${data.aws_route53_zone.primary-domain.name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.blogextractor-alb.dns_name}"
    zone_id                = "${aws_alb.blogextractor-alb.zone_id}"
    evaluate_target_health = false
  }
}

output "blogextractor-ips" {
	value = "${aws_instance.blogextractor.*.public_ip}"
}
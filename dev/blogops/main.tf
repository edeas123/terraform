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

output "blogextractor-1-ip" {
	value = "${aws_instance.blogextractor-1.public_ip}"
}

output "blogextractor-2-ip" {
	value = "${aws_instance.blogextractor-2.public_ip}"
}
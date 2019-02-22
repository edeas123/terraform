resource "aws_acm_certificate" "domain-ssl-cert" {
  domain_name = "*.mybytesni.com"
  validation_method = "DNS"
}

resource "aws_route53_record" "domain-ssl-cert-validation" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "${aws_acm_certificate.domain-ssl-cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.domain-ssl-cert.domain_validation_options.0.resource_record_type}"
  ttl     = 5
  records = ["${aws_acm_certificate.domain-ssl-cert.domain_validation_options.0.resource_record_value}"]
}

resource "aws_acm_certificate_validation" "domain-ssl-cert-validation" {
  certificate_arn         = "${aws_acm_certificate.domain-ssl-cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.domain-ssl-cert-validation.fqdn}"]
}

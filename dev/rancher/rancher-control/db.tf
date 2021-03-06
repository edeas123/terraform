data "vault_generic_secret" "rancher-rds" {
  path = "secret/rancher-rds"
}

resource "aws_db_instance" "rancher-ctl-rds" {
  identifier           = "rancher-ctl-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  apply_immediately    = true
  skip_final_snapshot  = true
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids = ["${data.terraform_remote_state.core.rancher-ctl-rds-sg-id}"]
  name                 =  "${data.vault_generic_secret.rancher-rds.data["database"]}",
  username             =  "${data.vault_generic_secret.rancher-rds.data["username"]}",
  password             =  "${data.vault_generic_secret.rancher-rds.data["password"]}"
}

resource "aws_route53_record" "rancher-ctl-rds-cname-record" {
  zone_id = "${data.aws_route53_zone.primary-domain.zone_id}"
  name    = "rancherdb.${data.aws_route53_zone.primary-domain.name}"
  type    = "CNAME"
  ttl     = 5
  records = ["${aws_db_instance.rancher-ctl-rds.address}"]
}
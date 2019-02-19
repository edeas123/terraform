data "terraform_remote_state" "jenkins" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "jenkins.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "static-web-with-elb" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "static-web-with-elb.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "static-web-on-s3" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "static-web-on-s3.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "blogops" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "blogops.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "core.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "playground" {
  backend = "s3"
  config {
    bucket = "mybytesni-tfstate"
    key    = "playground.tfstate"
    region = "${var.region}"
  }
}

data "aws_availability_zones" "zones" {}

data "aws_route53_zone" "primary-domain" {
  name = "${var.domain}"
}

data "aws_ami" "ubuntu-ami" {
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

data "vault_generic_secret" "cidr" {
  path = "secret/cidr"
}
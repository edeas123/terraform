# TODO: use todo to get the vpc id

# list of the ids of all subnets in the vpc
data "aws_subnet_ids" "vpc_subnets" {
  vpc_id = "${var.vpc_id}"
}

data "terraform_remote_state" "jenkins" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "jenkins.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "static-web-with-elb" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "static-web-with-elb.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "static-web-on-s3" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "static-web-on-s3.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "blogops" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "blogops.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "core.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "playground" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "playground.tfstate"
    region = "${var.region}"
  }
}
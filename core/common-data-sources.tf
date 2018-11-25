# TODO: use todo to get the vpc id
# TODO: modify for cases of multiple security group
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

data "terraform_remote_state" "static-web" {
  backend = "s3"
  config {
    bucket = "mybytesni-terraform"
    key    = "static-web.tfstate"
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
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
variable "region" {
	default = "us-east-2"
}

variable "domain" {
	default = "mybytesni.com"
}

locals {
	trusted-cidrs = [
		"${var.home-cidr}",
    "${var.office-cidr}"
	]
}

variable "ubuntu-ami" {
  default = "ami-0653e888ec96eab9b"
}
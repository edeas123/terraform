variable "region" {
	default = "us-east-2"
}

variable "domain" {
	default = "mybytesni.com"
}

variable "home-cidr" {}

variable "office-cidr" {}

variable "vpn-cidr" {}

locals {
	trusted-cidrs = [
		"${var.home-cidr}",
    "${var.office-cidr}"
	]
}

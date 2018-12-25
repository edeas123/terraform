variable "region" {
	default = "us-east-2"
}

variable "domain" {
	default = "mybytesni.com"
}

locals {
	cidrs = [
		"${var.home-mac-cidr}"
	]
}
variable "region" {
	default = "us-east-2"
}

variable "domain" {
	default = "mybytesni.com"
}

locals {
	trusted-cidrs = [
    "${data.vault_generic_secret.cidr.data["home"]}",
		"${data.vault_generic_secret.cidr.data["office"]}",
    "${data.vault_generic_secret.cidr.data["vpn"]}"
	]
}

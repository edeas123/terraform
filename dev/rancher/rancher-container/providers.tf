# configure the default cloud provider
provider "aws" {
  	version 	= "1.54.0"
  	region		= "${var.region}"
}

# configure the vault provider
provider "vault" {
    version   = "1.5"
    address   = "${var.vault_address}"
}

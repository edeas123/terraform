# configure the default cloud provider
provider "aws" {
  	version 	= "1.42.0"
  	region		= "${var.region}"
}
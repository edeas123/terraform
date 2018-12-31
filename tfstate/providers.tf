# configure the default cloud provider
provider "aws" {
  	version 	= "1.54.0"
  	region		= "${var.region}"
}
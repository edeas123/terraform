# configure the default cloud provider
provider "aws" {
  	version 	= "1.42.0"
  	region		= "${var.region}"
}

# use this provider configuration when required
# mainly because of out-of-region s3 bucket i created
# did not work
# what worked was to temporarily change the main profile region
provider "aws" {
	alias		= "asia"
  	version 	= "1.42.0"
  	region 		= "ap-southeast-2"
}
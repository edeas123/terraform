terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "static-web-with-elb.tfstate"
		region = "us-east-1"
	}
}
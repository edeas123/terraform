terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "static-web-with-elb.tfstate"
		region = "us-east-2"
	}
}
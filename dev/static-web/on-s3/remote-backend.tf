terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "static-web-on-s3.tfstate"
		region = "us-east-1"
	}
}
terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "static-web.tfstate"
		region = "us-east-1"
	}
}
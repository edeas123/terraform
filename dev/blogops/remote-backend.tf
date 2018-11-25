terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "blogops.tfstate"
		region = "us-east-1"
	}
}
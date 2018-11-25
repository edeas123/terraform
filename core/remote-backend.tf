terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "core.tfstate"
		region = "us-east-1"
	}
}
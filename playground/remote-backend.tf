terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "playground.tfstate"
		region = "us-east-1"
	}
}
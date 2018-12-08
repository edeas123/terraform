terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "playground.tfstate"
		region = "us-east-2"
	}
}
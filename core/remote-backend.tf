terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "core.tfstate"
		region = "us-east-2"
	}
}
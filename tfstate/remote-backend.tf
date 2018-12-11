terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "tfstate.tfstate"
		region = "us-east-2"
	}
}
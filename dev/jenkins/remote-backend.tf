terraform {
	backend "s3" {
		bucket = "mybytesni-terraform"
		key = "jenkins.tfstate"
		region = "us-east-1"
	}
}
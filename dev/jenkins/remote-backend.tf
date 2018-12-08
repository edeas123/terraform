terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "jenkins.tfstate"
		region = "us-east-2"
	}
}
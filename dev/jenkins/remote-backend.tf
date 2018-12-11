terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "jenkins.tfstate"
		region = "us-east-2"
		dynamodb_table = "terraform-locking-table"
	}
}
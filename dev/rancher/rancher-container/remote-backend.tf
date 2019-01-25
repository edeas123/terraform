terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "rancher-container.tfstate"
		region = "us-east-2"
		dynamodb_table = "terraform-locking-table"
	}
}
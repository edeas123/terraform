terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "blogops.tfstate"
		region = "us-east-2"
		dynamodb_table = "terraform-locking-table"
	}
}
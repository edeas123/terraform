terraform {
	backend "s3" {
		bucket = "mybytesni-tfstate"
		key = "static-web-on-s3.tfstate"
		region = "us-east-2"		
		dynamodb_table = "terraform-locking-table"
	}
}
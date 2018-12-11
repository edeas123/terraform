
resource "aws_dynamodb_table" "terraform-locking-table" {
  name           = "terraform-locking-table"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Environment = "global-terraform"
    Terraform   = "True"
  }
}

resource "aws_s3_bucket" "mybytesni-tfstate" {
	bucket = "mybytesni-tfstate"
	force_destroy = true
	acl = "private"
}
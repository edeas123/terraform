# create an s3 bucket in a different region
resource "aws_s3_bucket" "an-empty-bucket" {
	bucket = "an-empty-bucket"
	provider = "aws.asia"
	force_destroy = true
	region = "ap-southeast-2"
	acl = "private"
}

# create a another s3 bucket just to keep your domain name
resource "aws_s3_bucket" "mybytesni" {
	bucket = "mybytesni"
	force_destroy = true
	acl = "private"
}

# create an s3 bucket for storing terraform state
resource "aws_s3_bucket" "mybytesni-terraform" {
	bucket = "mybytesni-terraform"
	force_destroy = true
}
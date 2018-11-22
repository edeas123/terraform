# create two buckets in different regions
resource "aws_s3_bucket" "a-bucket-in-far-away-land" {
	bucket = "a-bucket-in-far-away-land"
	force_destroy = true
	region = "ap-southeast-2"
	acl = "private"
}
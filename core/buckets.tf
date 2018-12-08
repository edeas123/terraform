# create a another s3 bucket just to keep your domain name literal
resource "aws_s3_bucket" "mybytesni" {
	bucket = "mybytesni"
	force_destroy = true
	acl = "private"
}
# create another s3 bucket to host a static website
resource "aws_s3_bucket" "a-static-website-bucket" {
	bucket = "a-static-website-bucket"
	acl = "private"
	force_destroy = true
	website {
		index_document = "index.html"
		error_document = "error.html"
	}
	policy = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
		"Sid": "PublicReadGetObject",
		"Effect": "Allow",
		"Principal": "*",
		"Action": "s3:GetObject",
		"Resource": "arn:aws:s3:::a-static-website-bucket/*"
		}
	]
}
POLICY
}

# upload the index html file to the s3 bucket
resource "aws_s3_bucket_object" "index-file" {
	bucket = "${aws_s3_bucket.a-static-website-bucket.bucket}"
	key = "index.html"
	source = "data/index.html"
	content_type = "text/html"
}

# upload the error html file to the s3 bucket
resource "aws_s3_bucket_object" "error-file" {
	bucket = "${aws_s3_bucket.a-static-website-bucket.bucket}"
	key = "error.html"
	source = "data/error.html"
	content_type = "text/html"
}
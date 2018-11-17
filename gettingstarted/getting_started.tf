provider "aws" {
  	version 	= "1.42.0"
  	region		= "${var.region}"
}

# resource "aws_instance" "example" {
# 	ami           = "${lookup(var.amis, var.region)}"
# 	instance_type = "t2.micro"
# 	# depends_on    = ["aws_s3_bucket.example"]

# 	provisioner "local-exec" {
# 		command   = "echo ${aws_instance.example.public_ip} > ip_address.txt"
# 	}
# }

# resource "aws_eip" "ip" {
# 	instance = "${aws_instance.example.id}"
# }

resource "aws_instance" "example_import" {
	ami           = "ami-0ff8a91507f77f867"
	instance_type = "t2.micro"
}

# output "ip" {
# 	value = "${aws_eip.ip.public_ip}"
# }
# resource "aws_s3_bucket" "example" {
# 	bucket = "edeas123-terraform-getting-started-guide"
# 	acl = "private"
# }

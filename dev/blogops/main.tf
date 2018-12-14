# TODO: two spot instances, 1 ASG with 1 additional instance, 1lb
output "blogextractor-1-ip" {
	value = "${aws_instance.blogextractor-1.public_ip}"
}

output "blogextractor-2-ip" {
	value = "${aws_instance.blogextractor-2.public_ip}"
}
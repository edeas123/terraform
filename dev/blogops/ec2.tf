resource "aws_instance" "blogextractor" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${aws_security_group.blogextractor-sg.id}"
	]
	tags {
		Name = "blogextractor"
	}
	count = 2
}
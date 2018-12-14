resource "aws_instance" "blogextractor-1" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
	tags {
		Name = "blogextractor-1"
	}
}

resource "aws_instance" "blogextractor-2" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
	tags {
		Name = "blogextractor-2"
	}
}

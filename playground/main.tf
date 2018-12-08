resource "aws_spot_instance_request" "playground-spot-1" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	spot_type = "one-time"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[2]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.playground-sg-id}"
	]
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "playground-spot-1"
	}
}

output "playground-spot-1-ip" {
	value = "${aws_spot_instance_request.playground-spot-1.public_ip}"
}
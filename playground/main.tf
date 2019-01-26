resource "aws_spot_instance_request" "playground-spot-1" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "t2.micro"
	spot_type = "one-time"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[2]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.playground-sg-id}",
    "${data.terraform_remote_state.core.ssh-sg-id}"
	]
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "playground-spot-1"
	}
}

resource "aws_spot_fleet_request" "playground-fleet-1" {
  iam_fleet_role = "arn:aws:iam::524932011419:role/aws-service-role/spotfleet.amazonaws.com/AWSServiceRoleForEC2SpotFleet"
  launch_specification = {
    ami	= "ami-0653e888ec96eab9b"
    instance_type = "m4.large"
    key_name = "deployer"
    availability_zone = "${data.aws_availability_zones.zones.names[0]}"
    vpc_security_group_ids = [
      "${data.terraform_remote_state.core.playground-sg-id}",
      "${data.terraform_remote_state.core.ssh-sg-id}"
	  ]
    tags {
      Name = "playground-spot-1"
    }
  }
  launch_specification = {
    ami	= "ami-0653e888ec96eab9b"
    instance_type = "m4.large"
    key_name = "deployer"
    availability_zone = "${data.aws_availability_zones.zones.names[2]}"
    vpc_security_group_ids = [
      "${data.terraform_remote_state.core.playground-sg-id}",
      "${data.terraform_remote_state.core.ssh-sg-id}"
    ]
    tags {
      Name = "playground-spot-1"
    }
  }
  target_capacity = 3
  allocation_strategy = "diversified"
	wait_for_fulfillment = true
	timeouts = {
		create = "3m"
	}  
}

output "playground-spot-1-ip" {
	value = "${aws_spot_instance_request.playground-spot-1.public_ip}"
}
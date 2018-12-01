# resource "aws_instance" "playground-1" {
# 	ami           = "ami-0f9cf087c1f27d9b1"
# 	instance_type = "t2.micro"
# 	key_name 	  = "deployer"
# 	availability_zone = "us-east-1a"
# 	vpc_security_group_ids = [
# 		"${data.terraform_remote_state.core.playground-sg-id}"
# 	]
#     tags = {
#         Name = "playground-1"
#     }
# }

resource "aws_spot_instance_request" "playground-spot-1" {
	ami	= "ami-0f9cf087c1f27d9b1"
	instance_type = "m3.large"
	key_name = "deployer"
	availability_zone = "us-east-1a"
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
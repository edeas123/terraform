resource "aws_instance" "playground-1" {
	ami           = "ami-0f9cf087c1f27d9b1"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	availability_zone = "us-east-1a"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.playground-sg-id}"
	]
    tags = {
        Name = "playground-1"
    }
}

output "playground-1-ip" {
	value = "${aws_instance.playground-1.public_ip}"
}
resource "aws_security_group" "blogextractor-sg" {
	name = "blogextractor-sg"
	description = "Security group for the blogextractor instances"
  	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow all inbound SSH connections"
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTP connections on port 80 used for the UI"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allows all outbound traffic from the instance"
	}

    tags {
        Name = "blogextractor"
    }
}
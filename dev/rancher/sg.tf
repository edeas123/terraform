

resource "aws_security_group" "rancher-ctl-host-sg" {
	name = "rancher-ctl-host-sg"
	description = "Security group for the rancher control host"
  	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow all inbound SSH connections"
	}

	ingress {
		from_port = 9345
		to_port = 9345
		protocol = "tcp"
		self = true
		description = "Allow communication between hosts on HA"
	}

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		security_groups = ["${aws_security_group.rancher-ctl-host-alb-sg.id}"]
		description = "Allow HTTP connections on port 8080 used for the UI"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allows all outbound traffic from the instance"
	}

  tags {
      Name = "rancher-ctl-host"
  }
}

resource "aws_security_group" "rancher-ctl-rds-sg" {
	name = "rancher-ctl-rds-sg"
	description = "Security group for the rancher database"
  	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

	ingress {
		from_port = 3306
		to_port = 3306
		protocol = "tcp"
    security_groups = ["${aws_security_group.rancher-ctl-host-sg.id}"]
		description = "Allow communication on the database port from only the rancher-ctl-host"
	}

  tags {
      Name = "rancher-ctl-rds"
  }
}

resource "aws_security_group" "rancher-ctl-host-alb-sg" {
	name = "rancher-ctl-host-alb-sg"
	description = "Security group for the rancher host alb"
  	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
    cidr_blocks = "${local.cidrs}"
		description = "Allow HTTP connections on port 80 used for the UI"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allows all outbound traffic from the alb"
	}

  tags {
      Name = "rancher-ctl-host-alb"
  }
}
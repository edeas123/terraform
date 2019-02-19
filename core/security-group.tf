# create a security group for the web servers
resource "aws_security_group" "web-sg" {
	name = "web-sg"
	description = "Security group for the web servers"
  vpc_id = "${aws_default_vpc.default.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTP connections on port 80"
	}

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allows all outbound traffic from the instance"
    }
    
    tags {
        Name = "web"
    }
}

resource "aws_security_group" "playground-sg" {
	name = "playground-sg"
	description = "Security group for the playground instances"
  vpc_id = "${aws_vpc.mybytesni.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allows all outbound traffic from the instance"
	}

    tags {
        Name = "playground"
    }
}

# create a security group for the jenkins server
resource "aws_security_group" "jenkins-sg" {
	name = "jenkins-sg"
	description = "Security group for the jenkins servers"
  vpc_id = "${aws_default_vpc.default.id}"

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTP connections on port 8080 used for the Jenkins UI"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allows all outbound traffic from the instance"
	}
    
    tags {
        Name = "jenkins"
    }
}

resource "aws_security_group" "ssh-sg" {
	name = "ssh-sg"
	description = "Security group allowing ssh access from trusted cidrs"
  vpc_id = "${aws_default_vpc.default.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${local.trusted-cidrs}"]
		description = "Allow SSH connections from trusted cidrs"

	}
    
    tags {
        Name = "ssh"
    }
}

resource "aws_security_group" "mybytesni-ssh-sg" {
	name = "mybytesni-ssh-sg"
	description = "Security group allowing ssh access from trusted cidrs"
  vpc_id = "${aws_vpc.mybytesni.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${local.trusted-cidrs}"]
    self = true
		description = "Allow SSH connections from trusted cidrs"

	}
    
    tags {
        Name = "mybytesni ssh"
    }
}

resource "aws_security_group" "blogextractor-sg" {
	name = "blogextractor-sg"
	description = "Security group for the blogextractor instances"
  vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

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


resource "aws_security_group" "rancher-container-host-sg" {
	name = "rancher-container-host-sg"
	description = "Security group for the rancher container host"
  vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

	ingress {
		from_port = 500
		to_port = 500
		protocol = "udp"
		self = true
		description = "Allow communication between container hosts"
	}

	ingress {
		from_port = 4500
		to_port = 4500
		protocol = "udp"
		self = true
		description = "Allow communication between container hosts"
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
      Name = "rancher-container-host"
  }
}

resource "aws_security_group" "rancher-ctl-host-sg" {
	name = "rancher-ctl-host-sg"
	description = "Security group for the rancher control host"
  vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"

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

resource "aws_security_group" "playground-rds-sg" {
	name = "playground-rds-sg"
	description = "Security group for the playground rds database"
  vpc_id = "${aws_vpc.mybytesni.id}"

	ingress {
		from_port = 3306
		to_port = 3306
		protocol = "tcp"
    security_groups = ["${aws_security_group.playground-sg.id}"]
		description = "Allow communication on the database port from only the playground-host"
	}

  tags {
      Name = "playground-rds"
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
    cidr_blocks = ["${local.trusted-cidrs}"]
		description = "Allow HTTP connections on port 80 used for the UI"
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
		description = "Allow HTTP connections on port 80 from container hosts"
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
output "jenkins-sg-id" {
  value = "${aws_security_group.jenkins-sg.id}"
}

output "web-sg-id" {
  value = "${aws_security_group.web-sg.id}"
}

output "playground-sg-id" {
  value = "${aws_security_group.playground-sg.id}"
}

output "ssh-sg-id" {
  value = "${aws_security_group.ssh-sg.id}"
}

output "mybytesni-ssh-sg-id" {
  value = "${aws_security_group.mybytesni-ssh-sg.id}"
}

output "blogextractor-sg-id" {
  value = "${aws_security_group.blogextractor-sg.id}"
}

output "rancher-container-host-sg-id" {
  value = "${aws_security_group.rancher-container-host-sg.id}"
}

output "rancher-ctl-host-sg-id" {
  value = "${aws_security_group.rancher-ctl-host-sg.id}"
}
output "rancher-ctl-rds-sg-id" {
  value = "${aws_security_group.rancher-ctl-rds-sg.id}"
}

output "playground-rds-sg-id" {
  value = "${aws_security_group.playground-rds-sg.id}"
}
output "rancher-ctl-host-alb-sg-id" {
  value = "${aws_security_group.rancher-ctl-host-alb-sg.id}"
}
# create a security group for the web servers
resource "aws_security_group" "web-sg" {
	name = "web-sg"
	description = "Security group for the web servers"
  	vpc_id = "${aws_default_vpc.default.id}"

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
  	vpc_id = "${aws_default_vpc.default.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow all inbound SSH connections"
	}

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
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow all inbound SSH connections"
	}

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
		cidr_blocks = "${local.cidrs}"
		description = "Allow SSH connections from trusted cidrs"

	}
    
    tags {
        Name = "ssh"
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
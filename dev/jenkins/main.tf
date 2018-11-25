
# TODO: attach a larger EBS volume
# TODO: output this value /var/lib/jenkins/secrets/initialAdminPassword
# provision the ec2 instance
resource "aws_instance" "jenkins-server-1" {
	ami           = "ami-0ff8a91507f77f867"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	availability_zone = "us-east-1a"
	vpc_security_group_ids = [
		"${aws_security_group.jenkins-sg.id}"
	]
	tags = {
		Name = "jenkins-server-1" 
	}
	user_data = "${file("make-jenkins-server.sh")}"
}

# create a security group for the jenkins server
resource "aws_security_group" "jenkins-sg" {
	name = "jenkins-sg"
	description = "Security group for the jenkins servers"
	vpc_id = "${var.vpc_id}" 

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

 egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 }
}

# output the instance public ip address
output "jenkins-server-1-ip" {
	value = "${aws_instance.jenkins-server-1.public_ip}"
}
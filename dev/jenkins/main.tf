
# TODO: attach a larger EBS volume
# TODO: output this value /var/lib/jenkins/secrets/initialAdminPassword
# provision the ec2 instance
resource "aws_instance" "jenkins-server-1" {
	ami           = "ami-0ff8a91507f77f867"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	availability_zone = "us-east-1a"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.jenkins-sg-id}"
	]
	tags = {
		Name = "jenkins-server-1" 
	}
	user_data = "${file("make-jenkins-server.sh")}"
}

# output the instance public ip address
output "jenkins-server-1-ip" {
	value = "${aws_instance.jenkins-server-1.public_ip}"
}
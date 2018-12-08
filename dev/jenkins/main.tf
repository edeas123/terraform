
# TODO: attach a larger EBS volume
# TODO: output this value /var/lib/jenkins/secrets/initialAdminPassword
# provision the ec2 instance
resource "aws_instance" "jenkins-server-1" {
	ami	= "ami-0cd3dfa4e37921605"
	instance_type = "t2.micro"
	key_name 	  = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
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
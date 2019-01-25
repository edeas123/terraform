
data "aws_ami" "rancher-container-host-ami" {
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  filter {
    name   = "name"
    values = ["rancher-container-host-ami"]
  }

  owners = ["self"]
}

resource "aws_launch_template" "rancher-container-host-lt" {
  name = "rancher-container-host-lt"
  description = "Launch template for the rancher controller host instances"
  image_id = "${data.aws_ami.rancher-container-host-ami.id}"
  instance_type = "t2.micro"
  key_name = "deployer"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.rancher-container-host-sg-id}",
		"${data.terraform_remote_state.core.ssh-sg-id}"
	]
	user_data = "${base64encode(file("make-rancher-container-host.sh"))}"
}

resource "aws_autoscaling_group" "rancher-container-host-asg" {
  name_prefix = "rancher-container-host-asg_"
  max_size = 4
  desired_capacity = 2
  min_size = 1
  launch_template = {
    name = "${aws_launch_template.rancher-container-host-lt.name}"
  }
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
  termination_policies = ["OldestInstance"]
}
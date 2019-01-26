
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

resource "aws_launch_configuration" "rancher-container-host" {
  name_prefix = "rancher-container-host-"
  image_id = "${data.aws_ami.rancher-container-host-ami.id}"
  instance_type = "m4.large"
  key_name = "deployer"
	security_groups = [
		"${data.terraform_remote_state.core.rancher-container-host-sg-id}",
		"${data.terraform_remote_state.core.ssh-sg-id}"
	]
  lifecycle = {
    create_before_destroy = true
  }
  spot_price = 0.18
	user_data = "${base64encode(file("make-rancher-container-host.sh"))}"
}

resource "aws_autoscaling_group" "rancher-container-host-asg" {
  name_prefix = "rancher-container-host-asg_"
  max_size = 4
  desired_capacity = 2
  min_size = 1
  launch_configuration = "${aws_launch_configuration.rancher-container-host.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
  termination_policies = ["OldestInstance"]
  tags = [
    {
      key = "Name",
      value = "rancher-container-host",
      propagate_at_launch = true
    }
  ]
  lifecycle = {
    create_before_destroy = true
  }
}
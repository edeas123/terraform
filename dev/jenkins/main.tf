resource "aws_spot_instance_request" "infra-host" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "m4.large"
	spot_type = "one-time"
	key_name = "deployer"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.jenkins-sg-id}",
    "${data.terraform_remote_state.core.ssh-sg-id}",
	]
  iam_instance_profile = "${data.terraform_remote_state.core.jenkins-role-iam-instance-profile-name}"
  subnet_id = "${data.terraform_remote_state.core.aws-subnet-ids[0]}"
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "Infra Host",
    Running = "Jenkins, Vault, Consul"
	}
  user_data = "${base64encode(file("make-jenkins-server.sh"))}"
}
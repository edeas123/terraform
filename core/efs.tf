# DO NOT TERMINATE

resource "aws_efs_file_system" "jenkins" {
  tags {
		Name = "Jenkins"
	}
}

resource "aws_efs_mount_target" "jenkins" {
  file_system_id = "${aws_efs_file_system.jenkins.id}"
  subnet_id = "${data.terraform_remote_state.core.aws-subnet-ids[0]}"
  security_groups = ["${data.terraform_remote_state.core.infra-sg-id}"]
}

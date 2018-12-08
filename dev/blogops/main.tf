
resource "aws_ecr_repository" "blogextractor" {
	name = "blogextractor"
}

resource "aws_ecr_lifecycle_policy" "blogextractor_lifecyle_policy" {
	repository = "${aws_ecr_repository.blogextractor.name}"
	policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Retain at most 1 image",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# TODO: two spot instances, 1 ASG with 1 additional instance, 1lb
# TODO: Use fleet instead
resource "aws_spot_instance_request" "blogextractor-spot-1" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "m5.large"
	spot_type = "one-time"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "blogextractor-spot-1"
	}
}

resource "aws_spot_instance_request" "blogextractor-spot-2" {
	ami	= "ami-0653e888ec96eab9b"
	instance_type = "m5.large"
	spot_type = "one-time"
	key_name = "deployer"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	vpc_security_group_ids = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
	wait_for_fulfillment = true
	timeouts {
		create = "3m"
	}
	tags {
		Name = "blogextractor-spot-2"
	}
}

# create an application load balancer
resource "aws_alb" "blogextractor-alb" {
	name = "blogextractor-alb"
	internal = false
	load_balancer_type = "application"
	ip_address_type  = "ipv4"

	subnets = ["${data.aws_subnet_ids.vpc_subnets.ids}"]
	security_groups = [
		"${data.terraform_remote_state.core.blogextractor-sg-id}"
	]
}

# create an application load balancer listener 
resource "aws_alb_listener" "blogextractor-alb-listener" {
	load_balancer_arn = "${aws_alb.blogextractor-alb.arn}"
	port = 5000
	protocol = "HTTP"

	default_action {
    	type             = "forward"
    	target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  	}
}

# create the application load balancer target group
resource "aws_alb_target_group" "blogextractor-target-group" {
	name = "blogextractor-target-group"
	port = 5000
	protocol = "HTTP"
	vpc_id = "${data.terraform_remote_state.core.default-vpc-id}"
}

# attach the two webserver instances to the target group
resource "aws_alb_target_group_attachment" "blogextractor-1-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  target_id        = "${aws_spot_instance_request.blogextractor-spot-1.spot_instance_id}"
  port             = 5000
}
resource "aws_alb_target_group_attachment" "blogextractor-2-target-group-instance" {
  target_group_arn = "${aws_alb_target_group.blogextractor-target-group.arn}"
  target_id        = "${aws_spot_instance_request.blogextractor-spot-2.spot_instance_id}"
  port             = 5000
}

output "blogextractor-spot-1-ip" {
	value = "${aws_spot_instance_request.blogextractor-spot-1.public_ip}"
}

output "blogextractor-spot-2-ip" {
	value = "${aws_spot_instance_request.blogextractor-spot-2.public_ip}"
}
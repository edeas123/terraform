variable "region" {
	default = "us-east-1"
}

# TODO: confirm the need for the double quotes in the map
# TODO: fix this amis thing, use it properly if at all
variable "amis" {
	type = "map"
	default = {
		"us-east-1" = "ami-b374d5a5"
    	"us-west-2" = "ami-4b32be2b"
	}
}

variable "vpc_id" {
	default = "vpc-6f3d7608"
}
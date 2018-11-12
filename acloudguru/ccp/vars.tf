variable "region" {
	default = "us-east-1"
}

# TODO: confirm the need for the double quotes in the map
variable "amis" {
	type = "map"
	default = {
		"us-east-1" = "ami-b374d5a5"
    	"us-west-2" = "ami-4b32be2b"
	}
}
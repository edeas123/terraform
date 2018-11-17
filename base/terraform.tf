
# configure the default cloud provider
provider "aws" {
  	version 	= "1.42.0"
  	region		= "us-east-1"
}

# create an ssh key call it deployer
# this is the key you will use as the base for deploying your
# infrastructure
resource "aws_key_pair" "deployer" {
	key_name = "deployer"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5ANN28P1151DWhWbEtNYgmOWiWTqpiLrq18ZcV3GOdt3KCCyPfQHhhnNMHAH2bSikb+jqwPrMkAIRosPE/XnGjfzLr5Lad71gPloA8J1AoB0ygg0vibm0qOU/LkuLNZHM2Km6SLFbvznvNlsdBHe0C91osAWeGn9kcW3zo95ZXPJipmdxeOkQK/b3DapUjeuO3zFhnX1t32hXrBo925irEhyLHemIU3yza5IgtRdhWvnT622w6VAo6pP7Slc29jG/0bu5R90TlAPLXVQLA4IyJVzM5zY5F8mh/K8bdu3jEJHOVldE8evgoUxOuX6Tr6bmyyCC89+gW87XWUFGTntvhR/h4xJ/j2wH7+SBlcE3LJCHcD/2tpJt5Xwrm4ZpU/tuT3Sd9+zzcNoIoNS7xDjjxQALN3OgxiqLK7jySFzOAMvklV9uYh+H6JmpunJm4f/Td/D+VR3mTjN4DZTNyFDJp8AlPR8WEDHzdSjhfLNnA3Y5GebqYUNQwKubDYytB4MhXBKAhujIQirLeuVUyzSgQXgEkaHOZDCxeP9SgUGrXwMga89br7378OuVPaUMEEuLnsE/VoSpEgb3iaZZE/upVYUPlS+HPzspB6Mrl1WO8uxhlW3+f7i/zlbLxTMSo/3X52Ar3+7+FX8CuITnPTtDZWKDI8YtaXHU6cgIFoDCjQ== edeas123@gmail.com"	
}


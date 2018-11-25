
# create an iam user for circleci
resource "aws_iam_user" "circleci" {
	name = "circleci"
}

# create the access key for the iam user
resource "aws_iam_access_key" "circleci-access-key" {
	user = "${aws_iam_user.circleci.name}"
	pgp_key = "mQINBFv6nVMBEADCPelJFH0Y5nYGfb3aj85yf+eZvaa5jbMN8z61mcV0dolWrqEAsaci3gFr0uSwdlOA24m0mTJZkp+vdGYEnm1UefkD0/nh59ZNeRQ3xQzHp7JdFoN43QXcgV1yLxr+0SLd2DRSfoVyuE/r/lncRD1j8AgLRHCUHR8YUmJDnBiuL9qUH9Z+tk2733B4PDM35rzG9U3JxA2PQcXTl2eYaHqV7yLWdLk4mdzszCk7/OZ/dTNIgUsVBsQTamNDsSLiVzgrtXFx7KnCpt581kQGPqhlbgm0dtg/NnWAoZ0GI1sOTqXIEwkjx79QL2eWS8pjhN0LzZOzcwSzqCzOuvpeEh9H7wzchmZJ9Hz1L5oSw1l///eZTeInVaAYYfNG2y7fPmPP7TEfSBtaaqH3uI0dbR5N5lKsh4jQkej42NIhaDsSeVnLJhRF6nTb3DMAQm+ra0Rqtk8WQa9qhVZzlKVLvznPW0mhQzPlp7dGQk4Fjd1z9fteMQ/8MT5UmjliamiFmecwQ/E1lwoajXxNOZfrYn3R7oajrNX0+HnMrzZDa50rphYruAzmaDVY6DA8+dimvO8NRg7hN1JQVaeL4ujzp9Dg+grxkobaFeAN0fDvGO2u58nSe+4EO+ILzm+fSRiQdKbgFoOi37wRSWnMJQgol5bwNzbz6D4DHwVwAVwXaeh6LQARAQABtCFjaXJjbGVjaSA8Y2lyY2xlY2lAbXlieXRlc25pLmNvbT6JAk4EEwEIADgWIQTsjN5bSiHq5mswnrx8lXt6BuSwgQUCW/qdUwIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRB8lXt6BuSwgV7CEAC+XpWaF885SBfYsX89HlRJUoYaCTfvLpShtgebC0AjSs4dSXBI4Lfq+S4Ny3V7IW2YZHHbVlbA8aL8j/53P071inWuE5UAYTa1kEjYG/iE9a+X0kkvsVyP35m+wbPS8TgGYiPvGi1JnWIOR4N1v9wUMPfzPmZjR25f47JKV3xKgSXZJKkF/zypbdNO2ryU3EfGbfBweruQzKdc5XZO3ieaQjbyXPV9g34C1PSfFP8kQcSPfVLcFEw5X/x+Reql/ViBl2+Dq/AOCSsCLeSKe8xzO3hEz2PTqurPVk0Lmlaj0BzE5nUF8471zgk84vqWUS35e5pkCVtTBnqEB6GLbAd83PuGHr20KBD6IukGSbChIE9T9t7/o4mgKWm0bu/dVkxnZdFeVxf0YtEZi99h7DOvLXiRMoDpJJBa+WP63zp3hN6cp0U4s/aI1W90ppNxjQan/Q2yZlDbQM8M5Jv2Gy6IN8/Ky5uZ0NTpXfZvlG+oxbk4mTs4uvmUhtinCYFhSo9jwwLk4MYd3oXRjVa3YQ/ruyxAWYT8Qgdj3bsHjcvjgSg6bNnkHdtbpZNpsoppW0fFpQ5rduffhmvJPoB3CPeTYwTAQFwtwbZqJmp13IeRIKfohSDMZ705U4gDyYoH8CAoCOyNcEypO8xPC06+J2vl2tDbEsNkRArEQ7ZHaLfzA7kCDQRb+p1TARAAtVnxrFrvBi3PUAGOjSDid98TV/z6WnCDg/rQ4wcVehCXfYP0HfdylujsInd7YRmyZNN4wXFZNYmHLqDB9WU+6ZhkuIN5BGx/NFwBsI/oBk45YFCVQAPOWWmKp7c7ScNfM87GiP57G9b/kByyNX5ttA9jE1Xx5W03pzEHZ3JjYha/uiiHz0V/zVe7qTIq2eMFFSFjOtYxkjS9CsjzGtpfE0AhgYqQnKl95yQKuzTSNu2UclMEL3nIkLaMJe0ZDRi7jlfm67OLu6C6K9N74SYP+H9jjazTy7T/gRM97uN3QbrABWOV8Ddtjy9q/T7iZ+gfiG/ipx8OhBBTey+vYuIJDz0Q76/z4ua1UeQpJUiEr45ig8OuMGF0v8Qnxl/3SD+LOVvOPoBg2cWD0q9sb7mjdA5bfLWU/V3vPSMO1+AwxHBgOj8Ei9trQiWA0n5yIboOD3Rvf0r0oev3FW4odN4E95A6sQYZ34av2vXYJNAHigS0TqO7OEzQIVMnzb27WsJDWB1KiTUKeGwD7oJHM/ouvYvXGeydYJcoTILxSGJznCFRCJm25+hQBJadnZKwJj5hLSCgYPcUYayLBt5QqISjNLS2pALstX7v3zzhk0SrZki97Fj+tXCq8wxZmRZzQlNj2Z54R/DqBautWyuyTDUksUyZPfXgw3UzCHjaf7dxj9kAEQEAAYkCNgQYAQgAIBYhBOyM3ltKIermazCevHyVe3oG5LCBBQJb+p1TAhsMAAoJEHyVe3oG5LCBw4cQALRRgTsCNpTw/c/M5QsfqDjms1NGzEniR0v+nIPG/F3tRPIWC7wxI7J+tPINKp7NxdGLXnpKptHgKd2bHzdwWulqnt9xfcXF1YH6foHCVr9AoZmM1HB7vIkoBLAoH8bZOIo27lBl0E9MvNdhtJ6j80HFDwoI7RBEoBISpqtsHmM6+ZDOe2zQ6bVK03RXInz0+dGmFIXEfrIPZu4Aw6cAnzwM9GYCFwul0Vhq6NFZg5ziptAbv7fEyKMgoPQthQPAVmKPxoY1qGYyQPW97CuecwtptfFPZTc1LMmsz32wzwUGbpgA+M3uWiRlkvYVYF6alBNXUCOh3bRSUF7dArN0Snr2Gw1qD4/iqfAX7BN+QEJVc6C1XDyGv/Zm0HG3vmmJ6BP06sTxebmIpDd3m0mTAsmLzLv4K8zAbC287XHB5Np5U2VI1naWvwSTaOSi9vgRSxtjaYvbVYXnulpFZkW22KOx5dSHspIT+CoIsaww5uT8ggSp+dt/Sss53pRe0p2IYpb+xCmUeo14kiPLm/FBRh+0K29qqGvq5na1pBxqieD0jO7y95I+A7WGlQmDrtfkwcE5yXMnGxppDy4DvhbsXOTNDE6RYKqg50Eb2QfniVtxZCxgjNjhoMfbjamJN6c7Wn1E5fJ41UHdZu05IDGbUFeMQ2TnD75pl05ek2iWk75K"
}

# attach a managed policy to the created role, for full access to ecr
resource "aws_iam_user_policy_attachment" "circleci-ecr-policy-attachment" {
  user       = "${aws_iam_user.circleci.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}


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
resource "aws_iam_role" "access_user" {
    name = "access_user"
    assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "codecommit" {
    role = aws_iam_role.access_user.name
    policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_role_policy_attachment" "sns" {
    role = aws_iam_role.access_user.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}



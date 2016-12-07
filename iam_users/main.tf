variable admin {default = "banjocat"}
provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_group" "admin" {
    name = "admin"
}

resource "aws_iam_group_policy" "admin_policy" {
    name = "admin_policy"
    group = "${aws_iam_group.admin.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_group_membership" "admin_team" {
    name = "admin_team"
    group = "${aws_iam_group.admin.name}"
    users = [
        "${aws_iam_user.admin_user.name}"
    ]
}

resource "aws_iam_user" "admin_user" {
    name = "${var.admin}"
}

resource "aws_iam_user_login_profile" "admin_login_profile" {
    user = "${aws_iam_user.admin_user.name}"
    pgp_key = "keybase:${var.admin}"
}

output "password" {
    value = "${aws_iam_user_login_profile.admin_login_profile.encrypted_password}"
}


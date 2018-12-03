resource "aws_iam_role" "bastion" {
  name = "bastion-role"
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

resource "aws_iam_role_policy" "bastion_eip" {
  role        = "${aws_iam_role.bastion.id}"
  name        = "associate_eip"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress",
        "ec2:Describe*",
        "ec2:ModifyInstanceAttribute"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bastion_s3" {
  role        = "${aws_iam_role.bastion.id}"
  name        = "get_github_ssh_key_from_s3"
  policy      = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":["s3:GetObject"],
      "Resource":[
        "${data.terraform_remote_state.vars.s3_deployer_ssh_private_key_arn}",
        "${data.terraform_remote_state.vars.s3_ansible_vault_file_arn}"
      ]
    },
    {
      "Effect":"Allow",
      "Action":["s3:ListBucket"],
      "Resource":[
        "${data.terraform_remote_state.vars.backup_bucket_arn}"
      ]
    },
    {
      "Effect":"Allow",
      "Action":[
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource":[
        "${data.terraform_remote_state.vars.backup_bucket_arn}/openvpn/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_ec2_ssh" {
  role        = "${aws_iam_role.bastion.id}"
  name        = "get_ssh_key_from_aws_iam"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "iam:ListUsers",
      "iam:GetGroup"
    ],
    "Resource": "*"
  }, {
    "Effect": "Allow",
    "Action": [
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys"
    ],
    "Resource": [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*"
    ]
  }, {
      "Effect": "Allow",
      "Action": "ec2:DescribeTags",
      "Resource": "*"
  }]
}
EOF
}

resource "aws_iam_instance_profile" "bastion" {
    name = "bastion_profile"
    role = "${aws_iam_role.bastion.name}"
}

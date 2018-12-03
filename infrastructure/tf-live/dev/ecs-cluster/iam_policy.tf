
resource "aws_iam_role" "ecs" {
  name_prefix        = "ecs-role"
  assume_role_policy = "${file("iam_policy/ecs-role.json")}"
}

/* ecs service scheduler role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name        = "${data.terraform_remote_state.vpc.environment}-ecs_service_role_policy"
  policy      = "${file("iam_policy/ecs-service-role-policy.json")}"
  role        = "${aws_iam_role.ecs.id}"
}

/* ec2 container instance role & policy */
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name    = "${data.terraform_remote_state.vpc.environment}-ecs_instance_role_policy"
  policy  = "${file("iam_policy/ecs-instance-role-policy.json")}"
  role    = "${aws_iam_role.ecs.id}"
}

resource "aws_iam_instance_profile" "ecs" {
    name = "${data.terraform_remote_state.vpc.environment}-ecs_profile"
    role = "${aws_iam_role.ecs.name}"
}

resource "aws_iam_role_policy" "aws_ec2_ssh" {
  role        = "${aws_iam_role.ecs.id}"
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
  }, {
    "Effect":"Allow",
    "Action":["s3:GetObject"],
    "Resource":[
      "${data.terraform_remote_state.vars.s3_deployer_ssh_private_key_arn}"
    ]
  }]
}
EOF
}
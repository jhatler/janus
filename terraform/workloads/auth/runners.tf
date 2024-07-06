data "aws_iam_policy_document" "gh_oidc_runners" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

resource "aws_iam_policy" "gh_oidc_runners" {
  name        = "gh-oidc-runners"
  path        = "/"
  description = "GitHub OIDC Runners Access"

  policy = data.aws_iam_policy_document.gh_oidc_runners.json
}

data "aws_iam_policy_document" "runners_ec2" {
  # checkov:skip=CKV_AWS_111:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_109:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_107:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_356:This will be addressed in a future PR
  statement {
    sid    = "AllowPackerCreateTemporaryInstances"
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateFleet",
      "ec2:CreateImage",
      "ec2:CreateKeyPair",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeFastLaunchImages",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "ec2:DetachVolume",
      "ec2:EnableFastLaunch",
      "ec2:EnableImageDeprecation",
      "ec2:GetPasswordData",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:RunInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "iam:GetInstanceProfile"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPackerAuthorizeTemporaryInstances"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [aws_iam_role.runners_controlled.arn]
  }

  statement {
    sid    = "AllowParamAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}


resource "aws_iam_policy" "runners_ec2" {
  name        = "runners-ec2"
  path        = "/"
  description = "GitHub Actions Runner EC2 Launch Access"

  policy = data.aws_iam_policy_document.runners_ec2.json
}

resource "aws_iam_role" "runners" {
  name               = "runners"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  managed_policy_arns = [
    aws_iam_policy.runners_ec2.arn,
    aws_iam_policy.ssm_agent.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
    aws_iam_policy.ubuntu_cloudimg_ecr.arn,
    aws_iam_policy.ubuntu_cloudimg_s3.arn,
    aws_iam_policy.scratch_ecr.arn,
    aws_iam_policy.janus_ecr.arn,
  ]
}

resource "aws_iam_role" "runners_controlled" {
  name               = "runners-controlled"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  managed_policy_arns = [
    aws_iam_policy.ssm_agent.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]
}

resource "aws_iam_instance_profile" "runners" {
  name = "runners"
  role = aws_iam_role.runners.name
}

resource "aws_iam_instance_profile" "runners_controlled" {
  name = "runners-controlled"
  role = aws_iam_role.runners_controlled.name
}

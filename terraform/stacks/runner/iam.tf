data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "gh_oidc_ec2" {
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
      "ec2:CreateTags"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/auth.gh-oidc"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/Name"
      values   = ["*"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "ec2:LaunchTemplate"
      values   = [module.runner_template_amd64.arn]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "ec2:LaunchTemplate"
      values   = [module.runner_template_arm64.arn]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/auth.gh-oidc"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [aws_iam_role.runner.arn]
  }
}

data "aws_iam_policy_document" "runner_ec2" {
  statement {
    sid    = "AllowPackerCreateTemporaryInstances"
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
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
    resources = [aws_iam_role.runner_controlled.arn]
  }

  statement {
    sid    = "AllowParamAccess"
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/auth.gh-oidc"
      values   = ["true"]
    }
  }
}

data "aws_launch_template" "runner_amd64" {
  name = "runner-amd64"
}

data "aws_launch_template" "runner_arm64" {
  name = "runner-arm64"
}

data "aws_iam_policy_document" "runner_ssm" {
  statement {
    sid    = "AllowAssociationLoggingAndAnsibleSSMConnections"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetEncryptionConfiguration",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [
      "arn:aws:s3:::ssm-session-manager-${data.aws_caller_identity.current.account_id}",
      "arn:aws:s3:::ssm-session-manager-${data.aws_caller_identity.current.account_id}/*"
    ]
  }
  statement {
    sid    = "AllowSessionLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowRunShellDocumentAccess"
    effect = "Allow"
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      data.aws_ssm_document.run_shell.arn
    ]
  }

  statement {
    sid    = "AllowCrossRunnerSessions"
    effect = "Allow"
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:${data.aws_caller_identity.current.account_id}:instance/*"
    ]
    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/aws:ec2launchtemplate:id"
      values = [
        data.aws_launch_template.runner_amd64.id,
        data.aws_launch_template.runner_arm64.id
      ]
    }
  }

  statement {
    sid    = "AllowSessionDescribe"
    effect = "Allow"
    actions = [
      "ssm:DescribeSessions"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSessionManagement"
    effect = "Allow"
    actions = [
      "ssm:ResumeSession",
      "ssm:TerminateSession"
    ]
    resources = ["arn:aws:ssm:*:*:session/*"]
  }

  statement {
    sid    = "DenyOtherSessions"
    effect = "Deny"
    actions = [
      "ssm:StartSession"
    ]
    resources = [
      "arn:aws:ec2:us-east-2:${data.aws_caller_identity.current.account_id}:instance/*"
    ]
    condition {
      test     = "Null"
      variable = "ssm:resourceTag/aws:ec2launchtemplate:id"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "gh_oidc_ec2" {
  name        = "gh-oidc-ec2"
  path        = "/"
  description = "GitHub OIDC EC2 Access"

  policy = data.aws_iam_policy_document.gh_oidc_ec2.json
}

resource "aws_iam_policy" "runner_ec2" {
  name        = "runner-ec2"
  path        = "/"
  description = "GitHub Actions Runner EC2 Launch Access"

  policy = data.aws_iam_policy_document.runner_ec2.json
}

resource "aws_iam_policy" "runner_ssm" {
  name        = "runner-ssm"
  path        = "/"
  description = "GitHub Actions Runner Access for Ansible SSM Connections"

  policy = data.aws_iam_policy_document.runner_ssm.json
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "runner" {
  name               = "runner"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  managed_policy_arns = [
    aws_iam_policy.runner_ec2.arn,
    aws_iam_policy.runner_ssm.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]

  tags = {
    "auth.gh-oidc" = "true"
  }
}

resource "aws_iam_role" "runner_controlled" {
  name               = "runner-controlled"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  managed_policy_arns = [
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]

  tags = {
    "auth.gh-oidc" = "true"
  }
}

resource "aws_iam_instance_profile" "runner" {
  name = "runner"
  role = aws_iam_role.runner.name
}

resource "aws_iam_instance_profile" "runner_controlled" {
  name = "runner-controlled"
  role = aws_iam_role.runner_controlled.name
}

data "aws_iam_policy_document" "assume_role_apigateway" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AmazonAPIGatewayPushToCloudWatchLogs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "cloudwatch_logs" {
  name               = "cloudwatch-logs"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_apigateway.json

  managed_policy_arns = [
    data.aws_iam_policy.AmazonAPIGatewayPushToCloudWatchLogs.arn
  ]
}

resource "aws_api_gateway_account" "self" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_logs.arn
}

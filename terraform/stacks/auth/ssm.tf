# tflint-ignore: terraform_unused_declarations
data "aws_ssm_document" "run_shell" {
  name = "SSM-SessionManagerRunShell"
}

# tflint-ignore: terraform_unused_declarations
data "aws_ssm_document" "apply_ansible_playbooks" {
  name = "ApplyAnsiblePlaybooks"
}

data "aws_iam_policy_document" "ssm_agent" {
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
    sid    = "AllowDescibeLogs"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowSessionLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:ssm-session-manager"]
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
}

resource "aws_iam_policy" "ssm_agent" {
  name        = "ssm-agent"
  path        = "/"
  description = "Permissions for the SSM Agents to connect to the SSM Session Manager"
  policy      = data.aws_iam_policy_document.ssm_agent.json
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_agent" {
  name               = "ssm-agent"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json

  managed_policy_arns = [
    aws_iam_policy.ssm_agent.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  ]
}

resource "aws_iam_instance_profile" "ssm_agent" {
  name = "ssm-agent"
  role = aws_iam_role.ssm_agent.name
}

##
## IAM resources for the network stack
##

# Flow Logging
data "aws_iam_policy_document" "vpc_flow" {
  statement {
    effect = "Allow"
    sid    = "Allow_FlowLogs_CloudWatch_LogGroups"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc-flow-log/*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Allow_FlowLogs_S3_Archive"

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
      "arn:aws:s3:::vpc-flow-${data.aws_caller_identity.current.account_id}",
      "arn:aws:s3:::vpc-flow-${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

data "aws_iam_policy_document" "vpc_flow_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow" {
  name               = "vpc-flow"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role.json
}

resource "aws_iam_role_policy" "vpc_flow" {
  name   = "vpc-flow"
  role   = aws_iam_role.vpc_flow.id
  policy = data.aws_iam_policy_document.vpc_flow.json
}

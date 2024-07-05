data "aws_iam_policy_document" "ubuntu_cloudimg_ecr" {
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/ubuntu-cloudimg"]
  }

  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ManageRepositoryContents"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/ubuntu-cloudimg"]
  }
}

resource "aws_iam_policy" "ubuntu_cloudimg_ecr" {
  name        = "ubuntu-cloudimg-ecr"
  path        = "/"
  description = "Access to Ubuntu Cloud Images on ECR"

  policy = data.aws_iam_policy_document.ubuntu_cloudimg_ecr.json
}

data "aws_iam_policy_document" "ubuntu_cloudimg_s3" {
  statement {
    effect = "Allow"
    sid    = "AllowS3Cache"
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
      "s3:ListBucketMultipartUploads",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::ubuntu-cloudimg-${data.aws_caller_identity.current.account_id}",
      "arn:aws:s3:::ubuntu-cloudimg-${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_iam_policy" "ubuntu_cloudimg_s3" {
  name        = "ubuntu-cloudimg-s3"
  path        = "/"
  description = "Access to Ubuntu Cloud Images on S3"

  policy = data.aws_iam_policy_document.ubuntu_cloudimg_s3.json
}

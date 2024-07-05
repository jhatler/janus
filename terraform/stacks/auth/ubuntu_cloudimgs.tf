data "aws_iam_policy_document" "ubuntu_cloudimgs_ecr" {
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/ubuntu-cloudimgs"]
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
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/ubuntu-cloudimgs"]
  }
}

resource "aws_iam_policy" "ubuntu_cloudimgs_ecr" {
  name        = "ubuntu-cloudimgs-ecr"
  path        = "/"
  description = "Access to Ubuntu Cloud Images on ECR"

  policy = data.aws_iam_policy_document.ubuntu_cloudimgs_ecr.json
}

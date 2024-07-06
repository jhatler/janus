data "aws_iam_policy_document" "janus_ecr" {
  statement {
    sid    = "ListImagesInRepository"
    effect = "Allow"
    actions = [
      "ecr:ListImages"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/janus"]
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
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/janus"]
  }
}

resource "aws_iam_policy" "janus_ecr" {
  name        = "janus-ecr"
  path        = "/"
  description = "Access to Janus Images on ECR"

  policy = data.aws_iam_policy_document.janus_ecr.json
}

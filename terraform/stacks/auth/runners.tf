
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

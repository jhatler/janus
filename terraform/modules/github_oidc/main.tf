# Per: https://github.com/aws-actions/configure-aws-credentials/blob/bd0758102444af2a09b9e47a2c93d0f091c1252d/README.md
#   Note that the thumbprint below has been set to all F's because the thumbprint is not used
#   when authenticating token.actions.githubusercontent.com. This is a special case used only
#   when GitHub's OIDC is authenticating to IAM. IAM uses its library of trusted CAs to authenticate.
resource "aws_iam_openid_connect_provider" "gh" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

resource "aws_iam_role" "gh_oidc" {
  name = "gh-oidc-${var.github_owner}--${var.github_repository}"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = "AllowGitHubOIDC"
        Principal = {
          Federated = aws_iam_openid_connect_provider.gh.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repository}:*"
          }
        }
      }
    ]
  })

  managed_policy_arns = var.role_policies
}


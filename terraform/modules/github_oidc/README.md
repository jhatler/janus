# GitHub OIDC Module

This module configures a role in an AWS account which can be assumed via GitHub OIDC tokens issued for each workflow run in a GitHub repository.

For more information on how this works, please see the [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) documentation from GitHub.

For more information on how to use this module, please see the [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials) GitHub Action.

## Usage

```hcl
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

module "github_oidc" {
  source = "spacelift.io/jhatler/github-oidc/aws"

  github_owner      = "jhatler"
  github_repository = "janus"

  role_policies = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    "arn:aws:iam::112233445566:policy/foo"
  ]
}
```

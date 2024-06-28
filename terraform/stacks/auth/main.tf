data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# module "github-oidc" {
#   source  = "spacelift.io/jhatler/github-oidc/aws"
#   version = "0.1.0"

#   # Required inputs
#   github_owner      = var.control_owner
#   github_repository = var.control_repository
#   role_policies = [
#     aws_iam_policy.gh_oidc_runners.arn
#   ]
# }

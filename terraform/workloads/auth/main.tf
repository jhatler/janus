data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "github-oidc" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-github-oidc/aws"
  providers = { aws = aws }

  version = "0.2.3"

  # Required inputs
  github_owner      = var.kernel_owner
  github_repository = var.kernel_repository
  role_policies = [
    aws_iam_policy.gh_oidc_runners.arn,
    aws_iam_policy.ubuntu_cloudimg_ecr.arn,
    aws_iam_policy.ubuntu_cloudimg_s3.arn,
    aws_iam_policy.scratch_ecr.arn,
    aws_iam_policy.janus_ecr.arn,
  ]
}

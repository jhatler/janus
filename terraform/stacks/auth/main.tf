data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "github-oidc" {
  #checkov:skip=CKV_TF_1: Spacelift modules should be retrieved from Spacelift Module Registry
  source  = "spacelift.io/jhatler/github-oidc/aws"
  version = "0.2.2"

  # Required inputs
  github_owner      = var.control_owner
  github_repository = var.control_repository
  role_policies = [
    aws_iam_policy.gh_oidc_runners.arn,
    aws_iam_policy.ubuntu_cloudimgs_ecr.arn,
    aws_iam_policy.scratch_ecr.arn,
    aws_iam_policy.janus_ecr.arn,
  ]
}

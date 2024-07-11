terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Kernel     = var.kernel
      Owner      = var.kernel_owner
      Repository = var.kernel_repository
      Branch     = var.kernel_branch
      Namespace  = var.kernel_namespace
      Registry   = var.kernel_registry
    }
  }
}

module "github_oidc_simple_usage" {
  source    = "../../"
  providers = { aws = aws }

  github_owner      = var.kernel_owner
  github_repository = var.kernel_repository

  role_policies = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}

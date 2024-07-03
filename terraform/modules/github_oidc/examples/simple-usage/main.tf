terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "github_oidc_simple_usage" {
  source = "../../"

  github_owner      = var.control_owner
  github_repository = var.control_repository

  role_policies = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}

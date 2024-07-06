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

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "kms_key_service_principal_access" {
  source    = "../../"
  providers = { aws = aws }

  name        = "test-${uuid()}"
  description = "A test key that grants access to cloudwatch logs."

  key_policy_statements = [
    {
      Sid    = "AllowCloudwatch"
      Effect = "Allow"
      Principal = {
        Service = "logs.${data.aws_region.current.name}.amazonaws.com"
      }
      Action = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      Resource = "*",
      Condition = {
        ArnEquals = {
          "kms:EncryptionContext:aws:logs:arn" : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:foo"
        }
      }
    }
  ]
}

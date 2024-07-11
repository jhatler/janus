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

module "kms_key_default_settings" {
  source    = "../../"
  providers = { aws = aws }

  name        = "test-${uuid()}"
  description = "A test key with default settings."
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "test-${uuid()}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_kms_grant" "default" {
  key_id            = module.kms_key_default_settings.key_id
  grantee_principal = aws_iam_role.example.arn
  operations = [
    "Decrypt",
    "Encrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "DescribeKey",
    "GenerateDataKeyPair",
    "GenerateDataKeyPairWithoutPlaintext"
  ]
}

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

# KMS Encryption is enforced by the module
data "aws_kms_alias" "symmetric" {
  name = "alias/${var.kernel_namespace}/harness/symmetric"
}

# Put bucket name in local so it can be used in multiple places easily
locals {
  bucket_name = "test-${uuid()}"
}

module "bucket" {
  source    = "../../"
  providers = { aws = aws }

  bucket     = local.bucket_name
  log_bucket = local.bucket_name

  kms_master_key_id = data.aws_kms_alias.symmetric.target_key_id
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = module.bucket.id

  rule {
    id = "expiration"

    status = "Enabled"

    # Expire files after some number of days
    expiration {
      days = 386
    }
  }
}

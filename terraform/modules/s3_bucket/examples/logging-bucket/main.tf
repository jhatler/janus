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

# Put bucket names in locals so they can be used in multiple places easily
locals {
  log_bucket_name = "test-${uuid()}"
  bucket_name     = "test-${uuid()}"
}

module "log_bucket" {
  source    = "../../"
  providers = { aws = aws }

  bucket     = local.log_bucket_name
  log_bucket = local.log_bucket_name

  kms_master_key_id = data.aws_kms_alias.symmetric.target_key_id
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket" {
  bucket = module.log_bucket.id

  rule {
    id = "expiration"

    status = "Enabled"

    # Keep logs no longer than 2 years
    expiration {
      days = 730
    }
  }

  # Logs shouldn't change, so expire versions quickly
  # Really just here in case someone accidentally deletes something
  rule {
    id = "versions"

    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

module "bucket" {
  source    = "../../"
  providers = { aws = aws }

  bucket     = local.bucket_name
  log_bucket = module.log_bucket.id

  kms_master_key_id = data.aws_kms_alias.symmetric.target_key_id
}

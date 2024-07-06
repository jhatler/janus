##
## Central S3 Access Logs Bucket Setup
##
module "s3_access_logs" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-s3-bucket/aws"
  providers = { aws = aws }

  version = "0.1.1"

  bucket     = "s3-access-${data.aws_caller_identity.current.account_id}"
  log_bucket = "s3-access-${data.aws_caller_identity.current.account_id}"

  kms_master_key_id = var.s3_access_logging_kms_key_arn
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_access_log_expiration" {
  bucket = module.s3_access_logs.id

  rule {
    id = "expiration"

    status = "Enabled"

    # Keep logs no longer than 3 years
    expiration {
      days = 1095
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

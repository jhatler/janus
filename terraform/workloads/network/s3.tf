module "s3_vpc_flow" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-s3-bucket/aws"
  providers = { aws = aws }

  version = "0.1.1"

  bucket     = "vpc-flow-${data.aws_caller_identity.current.account_id}"
  log_bucket = var.s3_access_logs_bucket_id

  kms_master_key_id = var.vpc_flow_kms_key_arn

  lifecycle_days_after_initiation = 7

  # A year of flow logs is kept in cloud watch, so these can move to IA/Glacier quickly
  lifecycle_days_before_ia      = 30
  lifecycle_days_before_glacier = 90
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_vpc_flow_expiration" {
  bucket = module.s3_vpc_flow.id

  rule {
    id = "expiration"

    status = "Enabled"

    # Keep flow logs no longer than 3 years
    expiration {
      days = 1095
    }
  }

  # Flow logs shouldn't change, so expire versions quickly
  # Really just here in case someone accidentally deletes something
  rule {
    id = "versions"

    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# S3 Setup
resource "aws_s3_bucket" "vpc_flow" {
  #checkov:skip=CKV_AWS_144: The flow logs in this bucket do not need replicated across regions
  #checkov:skip=CKV2_AWS_62: The flow logs do not require event notifications
  bucket = "vpc-flow-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "vpc_flow" {
  bucket = aws_s3_bucket.vpc_flow.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_logging" "vpc_flow" {
  bucket = aws_s3_bucket.vpc_flow.id

  target_bucket = var.s3_access_logs_bucket_id
  target_prefix = "${aws_s3_bucket.vpc_flow.id}/"
}

resource "aws_s3_bucket_versioning" "vpc_flow" {
  bucket = aws_s3_bucket.vpc_flow.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "vpc_flow" {
  bucket = aws_s3_bucket.vpc_flow.id

  rule {
    id = "vpc-flows"

    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    # A year of flow logs is kept in cloud watch, so these can move to IA/Glacier quickly
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Keep flow logs for only 3 years
    expiration {
      days = 1095
    }
  }

  # Flows shouldn't change, so expire versions quickly
  # Really just here in case someone accidentally deletes something
  rule {
    id = "vpc-flow-versions"

    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow" {
  bucket = aws_s3_bucket.vpc_flow.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.vpc_flow.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

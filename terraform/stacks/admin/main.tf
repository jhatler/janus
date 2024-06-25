data "aws_caller_identity" "current" {}

##
## S3 Default Access Settings
##
resource "aws_s3_bucket_public_access_block" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

##
## S3 Access Logs Bucket Setup
##
resource "aws_s3_bucket" "s3_access_logs" {
  #checkov:skip=CKV_AWS_144: The access logs in this bucket do not need replicated across regions
  #checkov:skip=CKV2_AWS_62: The access logs do not require event notifications
  bucket = "s3-access-${data.aws_caller_identity.current.account_id}"
}

# Log to itself
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.s3_access_logs.id

  target_bucket = aws_s3_bucket.s3_access_logs.id
  target_prefix = "${aws_s3_bucket.s3_access_logs.id}/"
}

resource "aws_s3_bucket_versioning" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  rule {
    id = "s3-access"

    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    transition {
      days          = 180
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 365
      storage_class = "GLACIER"
    }

    # Keep logs for only 3 years
    expiration {
      days = 1095
    }
  }

  # Logs shouldn't change, so expire versions quickly
  # Really just here in case someone accidentally deletes something
  rule {
    id = "s3-access-versions"

    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = 7
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 14
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_access_logs" {
  bucket = aws_s3_bucket.s3_access_logs.id

  #checkov:skip=CKV2_AWS_67: The access logs in this bucket sufficiently protected with the default, unrotated key
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

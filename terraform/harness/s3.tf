resource "aws_s3_bucket" "log_bucket" {
  #checkov:skip=CKV_AWS_144: Cross-region replication is supported yet
  #checkov:skip=CKV2_AWS_62: Event notifications are supported yet
  bucket = "test-harness-logs-${data.aws_caller_identity.current.account_id}"

  force_destroy = true

  tags = {
    Class = "Test"
  }
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_logging" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "${aws_s3_bucket.log_bucket.id}/"
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  depends_on = [
    aws_s3_bucket_versioning.log_bucket
  ]

  rule {
    id = "objects"

    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    transition {
      days          = 180
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 360
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.symmetric.arn
    }
  }
}

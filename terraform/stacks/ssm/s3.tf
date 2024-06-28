resource "aws_s3_bucket" "ssm_session_manager" {
  #checkov:skip=CKV_AWS_144: This bucket do not need replicated across regions
  #checkov:skip=CKV2_AWS_62: This bucket does not require event notifications
  #checkov:skip=CKV_AWS_21: This bucket does not require versioning
  bucket = "ssm-session-manager-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "ssm_session_manager" {
  bucket = aws_s3_bucket.ssm_session_manager.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_logging" "ssm_session_manager" {
  bucket = aws_s3_bucket.ssm_session_manager.id

  target_bucket = var.s3_access_logs_bucket_id
  target_prefix = "${aws_s3_bucket.ssm_session_manager.id}/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ssm_session_manager" {
  #checkov:skip=CKV2_AWS_67: Rotation is configured in a different stack
  bucket = aws_s3_bucket.ssm_session_manager.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.ssm_session_manager_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "ssm_session_manager" {
  #ts:skip=AWS.S3Bucket.IAM.High.0370 This is not needed for SSM Session Manager
  bucket = aws_s3_bucket.ssm_session_manager.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "ssm_session_manager" {
  bucket = aws_s3_bucket.ssm_session_manager.id

  depends_on = [
    aws_s3_bucket_versioning.ssm_session_manager
  ]

  rule {
    id = "default"

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

    # Keep for only 3 years
    expiration {
      days = 1095
    }
  }
}

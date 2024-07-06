resource "aws_s3_bucket" "this" {
  #checkov:skip=CKV_AWS_144: Cross-region replication is supported yet
  #checkov:skip=CKV2_AWS_62: Event notifications are supported yet
  bucket = var.bucket
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
}

resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id

  target_bucket = var.log_bucket
  target_prefix = "${aws_s3_bucket.this.id}/"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  depends_on = [
    aws_s3_bucket_versioning.this
  ]

  rule {
    id = "objects"

    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = var.lifecycle_days_after_initiation
    }

    transition {
      days          = var.lifecycle_days_before_ia
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.lifecycle_days_before_glacier
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

# Object Expiration

This is example shows how to configure version expiration on an S3 bucket created by this module.

```hcl
# KMS Encryption is enforced by the module
data "aws_kms_alias" "symmetric" {
  name = "alias/${var.kernel_namespace}/harness/symmetric"
}

# Put bucket name in local so it can be used in multiple places easily
locals {
  bucket_name = "test-${uuid()}"
}

module "bucket" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-s3-bucket/aws"
  providers = { aws = aws }

  bucket     = local.bucket_name
  log_bucket = local.bucket_name

  kms_master_key_id = data.aws_kms_alias.symmetric.target_key_id
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = module.bucket.id

  # discard versions after some number of days
  rule {
    id = "versions"

    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 128
    }
  }
}
```

# Object Expiration

This is example shows how to configure object expiration on an S3 bucket created by this module.

```hcl
# KMS Encryption is enforced by the module
data "aws_kms_alias" "symmetric" {
  name = "${var.kernel_namespace}/harness/symmetric"
}

# Put bucket name in local so it can be used in multiple places easily
locals {
  bucket_name = "test-${uuid()}"
}

module "bucket" {
  source = "alias/${var.kernel_registry}/${var.kernel_namespace}-s3-bucket/aws"
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
```

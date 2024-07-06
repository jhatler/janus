# S3 Bucket Module

This module creates an S3 bucket with the following features:

- Public access block
- Versioning
- Server-side encryption with KMS Bucket Key
- Access logging
- Parameterized Lifecycle policy covering:
  - Transition to Infrequent Access
  - Transition to Glacier
  - Abort incomplete multipart uploads

## Usage

```hcl
module "key" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-kms-key/aws"
  providers = { aws = aws }

  name = "foo_key"
  description = "The key for foo bucket"
}

module "bucket" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-s3-bucket/aws"
  providers = { aws = aws }

  bucket = "foo"
  log_bucket = "bar"

  kms_master_key_id = module.key.arn
}
```

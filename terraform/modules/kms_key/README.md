# S3 Bucket Module

This module creates a KMS key and configures if for use via KMS Key Grants. The key can optionally be configued to grant access to AWS services via the `key_policy_statements` variable. All keys have the following features:

- Key Rotation by default every 365 days
- Ensures key alias is set to the key name

The key can be also configured with these optional features:

- Mutli-region replication
- Tagging

## Usage

```hcl
module "key" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-kms-key/aws"
  providers = { aws = aws }

  name = "foo_key"
  description = "The key for foo."
}
```

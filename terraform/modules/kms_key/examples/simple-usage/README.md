# Simple Usage

This is a simple example of creating a KMS key with default settings.

```hcl
module "kms_key_default_settings" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-kms-key/aws"
  providers = { aws = aws }

  name        = "test-${uuid()}"
  description = "A test key with default settings."
}
```

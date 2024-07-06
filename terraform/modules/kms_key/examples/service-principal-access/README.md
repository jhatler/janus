# Granting AWS Service Access to a KMS Key

This example shows how to create a KMS key and grant an AWS service access to it via the `key_policy_statements` variable.

```hcl
data "aws_region" "current" {}

module "kms_key_service_principal_access" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-kms-key/aws"
  providers = { aws = aws }

  name        = "test-${uuid()}"
  description = "A test key that grants access to cloudwatch logs."

  key_policy_statements = [
    {
      Sid    = "AllowCloudwatch"
      Effect = "Allow"
      Principal = {
        Service = "logs.${data.aws_region.current.name}.amazonaws.com"
      }
      Action = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      Resource = "*"
    }
  ]
}
```

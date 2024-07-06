# Granting IAM Role Access to a KMS Key

This example shows how to create a KMS key with default settings and grant an IAM role access to the key.

```hcl
module "kms_key_default_settings" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-kms-key/aws"
  providers = { aws = aws }

  name        = "test-${uuid()}"
  description = "A test key with default settings."
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = "lambda.amazonaws.com"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "example" {
  name               = "test-${uuid()}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_kms_grant" "default" {
  key_id            = module.kms_key_default_settings.key_id
  grantee_principal = aws_iam_role.example.arn
  operations = [
    "Decrypt",
    "Encrypt",
    "GenerateDataKey",
    "GenerateDataKeyWithoutPlaintext",
    "ReEncryptFrom",
    "ReEncryptTo",
    "DescribeKey",
    "GenerateDataKeyPair",
    "GenerateDataKeyPairWithoutPlaintext"
  ]
}
```

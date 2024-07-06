resource "aws_kms_key" "symmetric" {
  description = "Test Harness - Symmetric KMS Key"

  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  enable_key_rotation     = true
  rotation_period_in_days = 365

  is_enabled   = true
  multi_region = false

  tags = {
    Class = "Test"
  }
}

data "aws_iam_policy_document" "aws_kms_key_symmetric" {
  statement {
    sid = "EnableIAMUserPermissions"

    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_kms_key_policy" "symmetric" {
  key_id = aws_kms_key.symmetric.id
  policy = jsonencode({
    Id = "${var.kernel_namespace}/harness/symmetric"
    Statement = [
      {
        Sid = "EnableIAMUserPermissions"

        Action   = "kms:*"
        Effect   = "Allow"
        Resource = "*"

        Principal = {
          AWS = "*"
        }
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_kms_alias" "symmetric" {
  name          = "alias/${var.kernel_namespace}/harness/symmetric"
  target_key_id = aws_kms_key.symmetric.key_id
}


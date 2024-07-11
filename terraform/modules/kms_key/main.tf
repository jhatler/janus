data "aws_caller_identity" "current" {}
data "aws_default_tags" "this" {}

resource "aws_kms_key" "this" {
  description = var.description

  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec

  enable_key_rotation     = true
  rotation_period_in_days = var.rotation_period_in_days

  is_enabled   = var.is_enabled
  multi_region = var.multi_region

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
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

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = jsonencode({
    Id = "${data.aws_default_tags.this.tags["Namespace"]}/${var.name}"
    Statement = flatten([
      {
        Sid = "EnableIAMUserPermissions"

        Action   = "kms:*"
        Effect   = "Allow"
        Resource = "*"

        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
      var.key_policy_statements
    ])
    Version = "2012-10-17"
  })
}

resource "aws_kms_alias" "this" {
  name          = "alias/${data.aws_default_tags.this.tags["Namespace"]}/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}


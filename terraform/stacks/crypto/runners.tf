##
## KMS resources for the runners stack
##

resource "aws_kms_key" "runners" {
  description = "Used to encrypt data used by CI Runners"

  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "runners"
    Statement = [
      {
        Sid    = "EnableIAMUserPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "runners" {
  name          = "alias/runners"
  target_key_id = aws_kms_key.runners.key_id
}

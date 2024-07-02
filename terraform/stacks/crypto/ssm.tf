resource "aws_kms_key" "ssm_session_manager" {
  description = "Used to encrypt SSM Session Manager data"

  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-1"
    Statement = [
      {
        Sid    = "EnableIAMUserPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchSSMSessionManagerlogs"
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
        Condition = {
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:ssm-session-manager"
          }
        }
      },
      {
        Sid    = "AllowRunners"
        Effect = "Allow"
        Principal = {
          AWS = var.runners_role_arn
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowSSMAgents"
        Effect = "Allow"
        Principal = {
          AWS = var.ssm_agent_role_arn
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowRunnerControlledInstances"
        Effect = "Allow"
        Principal = {
          AWS = var.runners_controlled_role_arn
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
  })
}

resource "aws_kms_alias" "ssm_session_manager" {
  name          = "alias/ssm-session-manager"
  target_key_id = aws_kms_key.ssm_session_manager.key_id
}

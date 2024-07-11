##
## KMS resources for the ssm stack
##
locals {
  # These are the ARNs that should be allowed to use the ssm_session_manager KMS key
  kms_key_ssm_session_manager_allow = [
    var.runners_role_arn,
    var.ssm_agent_role_arn,
    var.runners_controlled_role_arn
  ]
}

module "kms_key_ssm_session_manager" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-kms-key/aws"
  providers = { aws = aws }

  version = "0.1.0"

  name        = "ssm_session_manager"
  description = "Used to encrypt SSM Session Manager data"

  key_policy_statements = [
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
    }
  ]
}

resource "aws_kms_grant" "ssm_session_manager" {
  count = length(local.kms_key_ssm_session_manager_allow)

  key_id            = module.kms_key_ssm_session_manager.key_id
  grantee_principal = local.kms_key_ssm_session_manager_allow[count.index]
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

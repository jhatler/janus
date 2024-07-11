##
## KMS resources for the runners stack
##
locals {
  # These are the ARNs that should be allowed to use the runners KMS key
  kms_key_runners_allow = [
    var.runners_role_arn,
    var.runners_controlled_role_arn,
    var.github_webhook_lambda_role_arn
  ]
}

module "kms_key_runners" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-kms-key/aws"
  providers = { aws = aws }

  version = "0.1.0"

  name        = "runners"
  description = "Used to encrypt data used by CI Runners"
}

resource "aws_kms_grant" "runners" {
  count = length(local.kms_key_runners_allow)

  key_id            = module.kms_key_runners.key_id
  grantee_principal = local.kms_key_runners_allow[count.index]
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

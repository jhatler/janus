##
## KMS resources for the network stack
##
module "kms_key_s3_access" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-kms-key/aws"
  providers = { aws = aws }

  version = "0.1.0"

  name        = "s3-access"
  description = "Used to encrypt S3 access logs"

  key_policy_statements = [
    {
      Sid    = "AllowS3Logging"
      Effect = "Allow"
      Principal = {
        Service = "logging.s3.amazonaws.com"
      }
      Action = [
        "kms:*"
      ]
      Resource = "*"
      Condition = {
        StringEquals = {
          "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}

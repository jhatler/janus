##
## KMS resources for the network stack
##
module "kms_key_vpc_flow" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-kms-key/aws"
  providers = { aws = aws }

  version = "0.1.0"

  name        = "vpc-flow"
  description = "Used to encrypt captured VPC Flows"

  key_policy_statements = [
    {
      Sid    = "AllowCloudWatchUsage"
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
          "kms:EncryptionContext:aws:logs:arn" : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:vpc-flow"
        }
      }
    },
    {
      Sid    = "AllowVPCFlowLogsUsage"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      Resource = "*",
      Condition = {
        ArnLike = {
          "aws:SourceArn" : "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc-flow-log/*"
        }
        StringEquals = {
          "aws:SourceAccount" : "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}

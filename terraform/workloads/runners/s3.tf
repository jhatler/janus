##
## Central S3 Access Logs Bucket Setup
##
module "s3_ubuntu_cloudimg" {
  source    = "$KERNEL_REGISTRY/$KERNEL_NAMESPACE-s3-bucket/aws"
  providers = { aws = aws }

  version = "0.1.1"

  bucket     = "ubuntu-cloudimg-${data.aws_caller_identity.current.account_id}"
  log_bucket = "s3-access-${data.aws_caller_identity.current.account_id}"

  kms_master_key_id = var.runners_kms_key_arn
}

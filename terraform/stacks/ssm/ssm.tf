# tflint-ignore: terraform_unused_declarations
data "aws_ssm_document" "run_shell" {
  name = "SSM-SessionManagerRunShell"
}

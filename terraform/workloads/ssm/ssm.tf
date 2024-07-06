# tflint-ignore: terraform_unused_declarations
data "aws_ssm_document" "run_shell" {
  name = "SSM-SessionManagerRunShell"
}

# tflint-ignore: terraform_unused_declarations
resource "aws_ssm_document" "apply_ansible_playbooks" {
  name          = "ApplyAnsiblePlaybooks"
  document_type = "Command"
  content       = file("${path.module}/files/ApplyAnsiblePlaybooks.json")
  target_type   = "/AWS::EC2::Instance"
}

# tflint-ignore: terraform_unused_declarations
data "aws_ssm_document" "apply_ansible_playbooks" {
  name = "ApplyAnsiblePlaybooks"
}

resource "aws_ssm_association" "runners_launch" {
  association_name = "runners-launch"

  name = data.aws_ssm_document.apply_ansible_playbooks.name

  max_concurrency = "100%"

  targets {
    key    = "tag:class"
    values = ["runner"]
  }

  output_location {
    s3_bucket_name = var.ssm_session_manager_bucket
    s3_key_prefix  = "associations/runners-launch/"
  }

  parameters = {
    SourceRepo     = "https://github.com/${var.kernel_owner}/${var.kernel_repository}.git"
    SourceRef      = "main"
    AnsibleRoot    = "ansible/runners"
    PlaybookFile   = "ssm.yml"
    ExtraVariables = "ansible_connection=local actions_runner_name=runner"
    ExtraArgs      = "-t launch"
    Check          = "False"
    Verbose        = "-v"
  }
}


resource "aws_ssm_association" "runners" {
  association_name = "runners"

  name = data.aws_ssm_document.apply_ansible_playbooks.name

  max_concurrency = "100%"

  apply_only_at_cron_interval = true

  schedule_expression = "cron(0 0/4 * * ? *)"

  targets {
    key    = "tag:class"
    values = ["runner"]
  }

  output_location {
    s3_bucket_name = var.ssm_session_manager_bucket
    s3_key_prefix  = "associations/runners/"
  }

  parameters = {
    SourceRepo     = "https://github.com/${var.kernel_owner}/${var.kernel_repository}.git"
    SourceRef      = "main"
    AnsibleRoot    = "ansible/runners"
    PlaybookFile   = "ssm.yml"
    ExtraVariables = "ansible_connection=local actions_runner_name=runner"
    ExtraArgs      = ""
    Check          = "False"
    Verbose        = "-v"
  }
}

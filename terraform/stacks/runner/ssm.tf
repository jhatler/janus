resource "aws_kms_key" "ssm_session_manager" {
  description = "Used to encrypt SSM Session Manager data"
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Runner instances to use the key for SSM Session Manager"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.runner.arn
        },
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
        Sid    = "Allow CloudWatch to use the key for SSM Session Manager logs"
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
  })
}

resource "aws_kms_alias" "ssm_session_manager" {
  name          = "alias/ssm-session-manager"
  target_key_id = aws_kms_key.ssm_session_manager.key_id
}

resource "aws_cloudwatch_log_group" "ssm_session_manager" {
  name       = "ssm-session-manager"
  kms_key_id = aws_kms_key.ssm_session_manager.arn
}

resource "aws_s3_bucket" "ssm_session_manager" {
  bucket = "ssm-session-manager-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ssm_session_manager" {
  bucket = aws_s3_bucket.ssm_session_manager.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ssm_session_manager.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_ssm_document" "run_shell" {
  name = "SSM-SessionManagerRunShell"
}

resource "aws_ssm_document" "apply_ansible_playbooks" {
  name          = "ApplyAnsiblePlaybooks"
  document_type = "Command"
  content       = file("${path.module}/files/ApplyAnsiblePlaybooks.json")
  target_type   = "/AWS::EC2::Instance"
}

resource "aws_ssm_association" "ansible_runner_launch" {
  association_name = "ansible-runner-launch"

  name = aws_ssm_document.apply_ansible_playbooks.name

  max_concurrency = "100%"

  targets {
    key    = "tag:class"
    values = ["runner"]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.ssm_session_manager.bucket
    s3_key_prefix  = "associations/ansible-runner-launch/"
  }

  parameters = {
    SourceRepo     = "https://github.com/${var.github_owner}/${var.github_repository}.git"
    SourceRef      = "210-migrate-container-builds-to-self-hosted-runners"
    AnsibleRoot    = "ansible/runner"
    PlaybookFile   = "ssm.yml"
    ExtraVariables = "ansible_connection=local actions_runner_name=runner"
    ExtraArgs      = "-t launch"
    Check          = "False"
    Verbose        = "-v"
  }
}


resource "aws_ssm_association" "ansible_runner" {
  association_name = "ansible-runner"

  name = aws_ssm_document.apply_ansible_playbooks.name

  max_concurrency = "100%"

  apply_only_at_cron_interval = true

  schedule_expression = "cron(0 0/4 * * ? *)"

  targets {
    key    = "tag:class"
    values = ["runner"]
  }

  output_location {
    s3_bucket_name = aws_s3_bucket.ssm_session_manager.bucket
    s3_key_prefix  = "associations/ansible-runner/"
  }

  parameters = {
    SourceRepo     = "https://github.com/${var.github_owner}/${var.github_repository}.git"
    SourceRef      = "210-migrate-container-builds-to-self-hosted-runners"
    AnsibleRoot    = "ansible/runner"
    PlaybookFile   = "ssm.yml"
    ExtraVariables = "ansible_connection=local actions_runner_name=runner"
    ExtraArgs      = ""
    Check          = "False"
    Verbose        = "-v"
  }
}

data "spacelift_account" "current" {}

locals {
  modules = [
    {
      name         = "${var.kernel_namespace}-github-oidc"
      description  = "(${var.kernel_namespace}) Configures GitHub access to IAM Role via OIDC"
      project_root = "terraform/modules/github_oidc",
      id           = "terraform-aws-${var.kernel_namespace}-github-oidc"
    },
    {
      name         = "${var.kernel_namespace}-runner-template"
      description  = "(${var.kernel_namespace}) Configures a runner template for GitHub Actions"
      project_root = "terraform/modules/runner_template",
      id           = "terraform-aws-${var.kernel_namespace}-runner-template"
    },
    {
      name         = "${var.kernel_namespace}-kms-key"
      description  = "(${var.kernel_namespace}) Creates a KMS key for use via KMS Key Grants."
      project_root = "terraform/modules/kms_key",
      id           = "terraform-aws-${var.kernel_namespace}-kms-key"
    },
    {
      name         = "${var.kernel_namespace}-s3-bucket"
      description  = "(${var.kernel_namespace}) Creates an S3 bucket with sane settings."
      project_root = "terraform/modules/s3_bucket",
      id           = "terraform-aws-${var.kernel_namespace}-s3-bucket"
    }
  ]

  workloads = [
    {
      name         = "${var.kernel_namespace}@Admin"
      description  = "(${var.kernel_namespace}) Central Administrative & Security Resources"
      project_root = "terraform/workloads/admin"
      id           = "${var.kernel_namespace}atadmin"
    },
    {
      name         = "${var.kernel_namespace}@Network"
      description  = "(${var.kernel_namespace}) Shared Network for all Stacks"
      project_root = "terraform/workloads/network"
      id           = "${var.kernel_namespace}atnetwork"
    },
    {
      name         = "${var.kernel_namespace}@Crypto"
      description  = "(${var.kernel_namespace}) Shared Cryptography for all Stacks"
      project_root = "terraform/workloads/crypto"
      id           = "${var.kernel_namespace}atcrypto"
    },
    {
      name         = "${var.kernel_namespace}@Runners"
      description  = "(${var.kernel_namespace}) Shared CI Runners for all Stacks"
      project_root = "terraform/workloads/runners"
      id           = "${var.kernel_namespace}atrunners"
    },
    {
      name         = "${var.kernel_namespace}@Webhooks"
      description  = "(${var.kernel_namespace}) API Gateway Endpoints for Webhook Automation"
      project_root = "terraform/workloads/webhooks"
      id           = "${var.kernel_namespace}atwebhooks"
    },
    {
      name         = "${var.kernel_namespace}@SSM"
      description  = "(${var.kernel_namespace}) AWS Systems Manager Automation"
      project_root = "terraform/workloads/ssm"
      id           = "${var.kernel_namespace}atssm"
    },
    {
      name         = "${var.kernel_namespace}@ECR"
      description  = "(${var.kernel_namespace}) ECR Repositories"
      project_root = "terraform/workloads/ecr"
      id           = "${var.kernel_namespace}atecr"
    }
  ]
}

# This is the auth stack, which shares our permissions
resource "spacelift_stack" "auth" {
  administrative = true
  autodeploy     = true

  github_action_deploy = false

  enable_well_known_secret_masking = true

  labels = [
    "${var.kernel_namespace}@aws",
    "${var.kernel_namespace}@infracost",
    "${var.kernel_namespace}@workload",
    "infracost",
    "terragrunt"
  ]

  branch            = var.kernel_branch
  description       = "(${var.kernel_namespace}) Authorization Stack"
  name              = "${var.kernel_namespace}@Auth"
  project_root      = "terraform/workloads/auth"
  repository        = var.kernel_repository
  terraform_version = "1.5.7"
}

resource "spacelift_aws_integration_attachment" "auth" {
  integration_id = spacelift_aws_integration.auth.id
  stack_id       = spacelift_stack.auth.id
  read           = true
  write          = true

  depends_on = [
    aws_iam_role.auth
  ]
}

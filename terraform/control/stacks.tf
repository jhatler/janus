locals {
  stacks_to_create = [
    {
      name         = "Admin"
      description  = "Central Administrative & Security Resources"
      project_root = "terraform/stacks/admin"
      id           = "admin"
    },
    {
      name         = "Network"
      description  = "Shared Network for all Stacks"
      project_root = "terraform/stacks/network"
      id           = "network"
    },
    {
      name         = "Crypto"
      description  = "Shared Cryptography for all Stacks"
      project_root = "terraform/stacks/crypto"
      id           = "crypto"
    },
    {
      name         = "Runners"
      description  = "Shared CI Runners for all Stacks"
      project_root = "terraform/stacks/runners"
      id           = "runners"
    },
    {
      name         = "Webhooks"
      description  = "API Gateway Endpoints for Webhook Automation"
      project_root = "terraform/stacks/webhooks"
      id           = "webhooks"
    },
    {
      name         = "SSM"
      description  = "AWS Systems Manager Automation"
      project_root = "terraform/stacks/ssm"
      id           = "ssm"
    },
    {
      name         = "Ubuntu"
      description  = "Ubuntu Cloud Images"
      project_root = "terraform/stacks/ubuntu_cloudimgs"
      id           = "ubuntu"
    },
    {
      name         = "Janus"
      description  = "Just Another Neural Utility System"
      project_root = "terraform/stacks/janus"
      id           = "janus"
    },
    {
      name         = "Scratch"
      description  = "Scratch Images"
      project_root = "terraform/stacks/scratch"
      id           = "scratch"
    }
  ]
}

resource "spacelift_stack" "children" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  administrative = false
  autodeploy     = true

  github_action_deploy = false

  enable_well_known_secret_masking = true

  repository = var.control_repository

  branch            = "main"
  terraform_version = "1.5.7"

  description  = each.value.description
  name         = each.value.name
  project_root = each.value.project_root

  labels = [
    "infracost",
    "aikido"
  ]
}

# Make all children dependent on the Control stack
resource "spacelift_stack_dependency" "integration__control" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  stack_id            = each.value.id
  depends_on_stack_id = spacelift_stack.control.id

  # The children need to exist before their dependencies can be defined
  depends_on = [
    spacelift_stack.children,
    spacelift_stack.control
  ]
}

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "integration" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  integration_id = spacelift_aws_integration.integration.id
  stack_id       = each.value.id
  read           = true
  write          = true

  depends_on = [
    spacelift_stack.children
  ]
}

resource "spacelift_aws_integration_attachment" "integration" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  integration_id = spacelift_aws_integration.integration.id
  stack_id       = each.value.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    spacelift_stack.children,
    aws_iam_role.integration
  ]
}

# Pass through the control owner and repository to chilren
resource "spacelift_environment_variable" "integration_control_owner" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  stack_id   = each.value.id
  name       = "TF_VAR_control_owner"
  value      = var.control_owner
  write_only = false

  depends_on = [
    spacelift_stack.children
  ]
}
resource "spacelift_environment_variable" "integration_control_repository" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  stack_id   = each.value.id
  name       = "TF_VAR_control_repository"
  value      = var.control_repository
  write_only = false

  depends_on = [
    spacelift_stack.children
  ]
}

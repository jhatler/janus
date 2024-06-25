locals {
  stacks_to_create = [
    {
      name         = "Hello World"
      description  = "Hello World Stack"
      project_root = "terraform/stacks/hello_world"
      id           = "hello-world"
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

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "integration" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  integration_id = spacelift_aws_integration.integration.id
  stack_id       = each.value.id
  read           = true
  write          = true
}

resource "spacelift_aws_integration_attachment" "integration" {
  for_each = { for stack in local.stacks_to_create : stack.name => stack }

  integration_id = spacelift_aws_integration.integration.id
  stack_id       = each.value.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    aws_iam_role.integration
  ]
}

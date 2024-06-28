locals {
  modules_to_create = [
    {
      name         = "github-oidc"
      description  = "Configures GitHub access to IAM Role via OIDC"
      project_root = "terraform/modules/github_oidc",
      id           = "terraform-aws-github-oidc"
    }
  ]
}

resource "spacelift_module" "control_modules" {
  for_each = { for module in local.modules_to_create : module.name => module }

  terraform_provider = "aws"
  branch             = "main"
  repository         = var.control_repository

  labels = [
    "module"
  ]

  name         = each.key
  description  = each.value.description
  project_root = each.value.project_root
}

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "control_modules" {
  for_each = { for module in local.modules_to_create : module.name => module }

  integration_id = spacelift_aws_integration.auth.id
  module_id      = each.value.id
  read           = true
  write          = true

  depends_on = [
    spacelift_module.control_modules
  ]
}

resource "spacelift_aws_integration_attachment" "control_modules" {
  for_each = { for module in local.modules_to_create : module.name => module }

  integration_id = spacelift_aws_integration.auth.id
  module_id      = spacelift_module.control_modules[each.key].id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    spacelift_module.control_modules,
    aws_iam_role.auth
  ]
}


resource "spacelift_module" "kernel_modules" {
  for_each = { for module in local.modules : module.name => module }

  terraform_provider = "aws"
  branch             = var.kernel_branch
  repository         = var.kernel_repository

  labels = [
    "${var.kernel_namespace}@aws",
    "${var.kernel_namespace}@module"
  ]

  name         = each.key
  description  = each.value.description
  project_root = each.value.project_root
}

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "kernel_modules" {
  for_each = { for module in local.modules : module.name => module }

  integration_id = spacelift_aws_integration.kernel_modules.id
  module_id      = each.value.id
  read           = true
  write          = true

  depends_on = [
    spacelift_module.kernel_modules
  ]
}

resource "spacelift_aws_integration_attachment" "kernel_modules" {
  for_each = { for module in local.modules : module.name => module }

  integration_id = spacelift_aws_integration.kernel_modules.id
  module_id      = spacelift_module.kernel_modules[each.key].id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    spacelift_module.kernel_modules,
    aws_iam_role.kernel_modules
  ]
}


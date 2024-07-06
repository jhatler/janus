resource "spacelift_stack" "workloads" {
  for_each = { for stack in local.workloads : stack.name => stack }

  administrative = false
  autodeploy     = true

  github_action_deploy = false

  enable_well_known_secret_masking = true

  repository = var.kernel_repository

  branch            = var.kernel_branch
  terraform_version = "1.5.7"

  description  = each.value.description
  name         = each.value.name
  project_root = each.value.project_root

  labels = [
    "${var.kernel_namespace}@aws",
    "${var.kernel_namespace}@infracost",
    "${var.kernel_namespace}@workload",
    "infracost",
    "terragrunt"
  ]
}

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "workloads" {
  for_each = { for stack in local.workloads : stack.name => stack }

  integration_id = spacelift_aws_integration.workloads.id
  stack_id       = each.value.id
  read           = true
  write          = true

  depends_on = [
    spacelift_stack.workloads
  ]
}

resource "spacelift_aws_integration_attachment" "workloads" {
  for_each = { for stack in local.workloads : stack.name => stack }

  integration_id = spacelift_aws_integration.workloads.id
  stack_id       = each.value.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    spacelift_stack.workloads,
    aws_iam_role.workloads
  ]
}

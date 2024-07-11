resource "spacelift_stack" "harness" {
  administrative = true
  autodeploy     = true

  github_action_deploy = false

  enable_well_known_secret_masking = true

  repository = var.kernel_repository

  branch            = var.kernel_branch
  terraform_version = "1.5.7"

  description  = "(${var.kernel_namespace}) Test Harness Resources"
  name         = "${var.kernel_namespace}@Harness"
  project_root = "terraform/harness"

  labels = [
    "${var.kernel_namespace}@aws",
    "${var.kernel_namespace}@infracost",
    "${var.kernel_namespace}@kernel",
    "infracost"
  ]
}

# Generate the External IDs required for creating our AssumeRole policy
data "spacelift_aws_integration_attachment_external_id" "harness" {
  integration_id = spacelift_aws_integration.harness.id
  stack_id       = spacelift_stack.harness.id
  read           = true
  write          = true

  depends_on = [
    spacelift_stack.harness
  ]
}

resource "spacelift_aws_integration_attachment" "harness" {
  integration_id = spacelift_aws_integration.harness.id
  stack_id       = spacelift_stack.harness.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    spacelift_stack.harness,
    aws_iam_role.harness
  ]
}

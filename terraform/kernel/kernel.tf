resource "spacelift_stack" "kernel" {
  administrative = true
  autodeploy     = true

  ### BOOTSTRAP: import_state_file = "terraform.tfstate"

  github_action_deploy = false

  enable_well_known_secret_masking = true

  labels = [
    "${var.kernel_namespace}@kernel",
    "${var.kernel_namespace}@aws",
    "${var.kernel_namespace}@infracost",
    "terragrunt",
    "infracost"
  ]

  branch            = var.kernel_branch
  description       = "(${var.kernel_namespace}) Kernel Stack"
  name              = "${var.kernel_namespace}@Kernel"
  project_root      = "terraform/kernel"
  repository        = var.kernel_repository
  terraform_version = "1.5.7"
}

resource "spacelift_aws_integration_attachment" "kernel" {
  integration_id = spacelift_aws_integration.kernel.id
  stack_id       = spacelift_stack.kernel.id
  read           = true
  write          = true

  depends_on = [
    aws_iam_role.kernel
  ]
}

output "TF_VAR_kernel_stack_slug" {
  value       = spacelift_stack.kernel.slug
  description = "The slug of the kernel stack."
  sensitive   = true
}

output "TF_VAR_kernel_aws_integration_id" {
  value       = spacelift_aws_integration_attachment.kernel.id
  description = "The ID of the AWS integration attached to the kernel stack."
  sensitive   = true
}

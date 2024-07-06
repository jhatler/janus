# Make all workloads dependent on the kernel
resource "spacelift_stack_dependency" "workloads__kernel" {
  for_each = { for stack in local.workloads : stack.name => stack }

  stack_id            = each.value.id
  depends_on_stack_id = spacelift_stack.kernel.id

  # The workloads need to exist before their dependencies can be defined
  depends_on = [
    spacelift_stack.workloads,
    spacelift_stack.kernel
  ]
}

resource "spacelift_stack_dependency" "auth__kernel" {
  stack_id            = spacelift_stack.auth.id
  depends_on_stack_id = spacelift_stack.kernel.id
}

resource "spacelift_stack_dependency_reference" "network_kernel_cidr_prefix" {
  stack_dependency_id = spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Network"].id
  output_name         = "TF_VAR_kernel_cidr_prefix"
  input_name          = "TF_VAR_kernel_cidr_prefix"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "auth_stack_role_id" {
  stack_dependency_id = spacelift_stack_dependency.auth__kernel.id
  output_name         = "TF_VAR_workloads_role_id"
  input_name          = "TF_VAR_workloads_role_id"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "runners_runner_admin_pat" {
  stack_dependency_id = spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Runners"].id
  output_name         = "TF_VAR_kernel_token"
  input_name          = "TF_VAR_runners_admin_pat"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "webhooks_github_token" {
  stack_dependency_id = spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Webhooks"].id
  output_name         = "TF_VAR_kernel_token"
  input_name          = "TF_VAR_github_token"
  trigger_always      = true
}

resource "spacelift_context" "module" {
  name        = "${var.kernel_namespace}@Module"
  description = "(${var.kernel_namespace}) Module Build Configuration"
  labels = [
    "autoattach:${var.kernel_namespace}@module"
  ]
}

resource "spacelift_environment_variable" "module_kernel" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel"
  value      = "${var.kernel_owner}/${var.kernel_repository}/${var.kernel_branch}/${var.kernel_namespace}"
  write_only = false
}

resource "spacelift_environment_variable" "module_kernel_namespace" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_namespace"
  value      = var.kernel_namespace
  write_only = false
}

resource "spacelift_environment_variable" "module_kernel_token" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_token"
  value      = var.kernel_token
  write_only = true
}

resource "spacelift_environment_variable" "module_kernel_repository" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_repository"
  value      = var.kernel_repository
  write_only = false
}

resource "spacelift_environment_variable" "module_kernel_owner" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_owner"
  value      = var.kernel_owner
  write_only = false
}

resource "spacelift_environment_variable" "module_kernel_branch" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_branch"
  value      = var.kernel_branch
  write_only = false
}

resource "spacelift_environment_variable" "module_kernel_registry" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_registry"
  value      = var.kernel_registry
  write_only = true
}

resource "spacelift_environment_variable" "module_kernel_cidr_prefix" {
  context_id = spacelift_context.module.id
  name       = "TF_VAR_kernel_cidr_prefix"
  value      = var.kernel_cidr_prefix
  write_only = true
}

resource "spacelift_context" "workloads" {
  name        = "${var.kernel_namespace}@Workload"
  description = "(${var.kernel_namespace}) Common Workload Runtime Configuration"
  labels = [
    "autoattach:${var.kernel_namespace}@workload"
  ]
}

resource "spacelift_environment_variable" "workloads_kernel" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel"
  value      = "${var.kernel_owner}/${var.kernel_repository}/${var.kernel_branch}/${var.kernel_namespace}"
  write_only = false
}

resource "spacelift_environment_variable" "workloads_kernel_namespace" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_namespace"
  value      = var.kernel_namespace
  write_only = false
}

resource "spacelift_environment_variable" "workloads_kernel_token" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_token"
  value      = var.kernel_token
  write_only = true
}

resource "spacelift_environment_variable" "workloads_kernel_repository" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_repository"
  value      = var.kernel_repository
  write_only = false
}

resource "spacelift_environment_variable" "workloads_kernel_owner" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_owner"
  value      = var.kernel_owner
  write_only = false
}

resource "spacelift_environment_variable" "workloads_kernel_branch" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_branch"
  value      = var.kernel_branch
  write_only = false
}

resource "spacelift_environment_variable" "workloads_kernel_registry" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_registry"
  value      = var.kernel_registry
  write_only = true
}

resource "spacelift_environment_variable" "workloads_kernel_cidr_prefix" {
  context_id = spacelift_context.workloads.id
  name       = "TF_VAR_kernel_cidr_prefix"
  value      = var.kernel_cidr_prefix
  write_only = true
}

resource "spacelift_context" "kernel" {
  name        = "${var.kernel_namespace}@Kernel"
  description = "(${var.kernel_namespace}) Kernel Credentials and Configuration"
  labels = [
    "autoattach:${var.kernel_namespace}@kernel"
  ]
}

resource "spacelift_environment_variable" "kernel_kernel_namespace" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_namespace"
  value      = var.kernel_namespace
  write_only = false
}

resource "spacelift_environment_variable" "kernel_kernel_token" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_token"
  value      = var.kernel_token
  write_only = true
}

resource "spacelift_environment_variable" "kernel_kernel_repository" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_repository"
  value      = var.kernel_repository
  write_only = false
}

resource "spacelift_environment_variable" "kernel_kernel_owner" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_owner"
  value      = var.kernel_owner
  write_only = false
}

resource "spacelift_environment_variable" "kernel_kernel_branch" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_branch"
  value      = var.kernel_branch
  write_only = false
}

resource "spacelift_environment_variable" "kernel_kernel_cidr_prefix" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_cidr_prefix"
  value      = var.kernel_cidr_prefix
  write_only = true
}

resource "spacelift_environment_variable" "kernel_aws_default_region" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_aws_default_region"
  value      = var.aws_default_region
  write_only = false
}

resource "spacelift_environment_variable" "kernel_aws_account_id" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_aws_account_id"
  value      = var.aws_account_id
  write_only = true
}

resource "spacelift_environment_variable" "kernel_kernel_registry" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_kernel_registry"
  value      = var.kernel_registry
  write_only = true
}

resource "spacelift_environment_variable" "kernel_spacelift_organization" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_spacelift_organization"
  value      = var.spacelift_organization
  write_only = true
}

resource "spacelift_environment_variable" "kernel_spacelift_api_key_endpoint" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_spacelift_api_key_endpoint"
  value      = var.spacelift_api_key_endpoint
  write_only = true
}

resource "spacelift_environment_variable" "kernel_spacelift_api_key_id" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_spacelift_api_key_id"
  value      = var.spacelift_api_key_id
  write_only = true
}

resource "spacelift_environment_variable" "kernel_spacelift_api_key_secret" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_spacelift_api_key_secret"
  value      = var.spacelift_api_key_secret
  write_only = true
}

resource "spacelift_environment_variable" "kernel_aikido_secret_key" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_aikido_secret_key"
  value      = var.aikido_secret_key
  write_only = true
}

resource "spacelift_environment_variable" "kernel_infracost_api_key" {
  context_id = spacelift_context.kernel.id
  name       = "TF_VAR_infracost_api_key"
  value      = var.infracost_api_key
  write_only = true
}

resource "spacelift_context" "infracost" {
  name        = "${var.kernel_namespace}@Infracost"
  description = "(${var.kernel_namespace}) Infracost access for cost estimation"
  labels = [
    "autoattach:${var.kernel_namespace}@infracost"
  ]
}

resource "spacelift_environment_variable" "infracost_infracost_api_key" {
  context_id = spacelift_context.infracost.id
  name       = "INFRACOST_API_KEY"
  value      = var.infracost_api_key
  write_only = true
}

resource "spacelift_context" "aws" {
  name        = "${var.kernel_namespace}@AWS"
  description = "(${var.kernel_namespace}) default AWS settings"
  labels = [
    "autoattach:${var.kernel_namespace}@aws"
  ]
}

resource "spacelift_environment_variable" "aws_aws_default_region" {
  context_id = spacelift_context.aws.id
  name       = "AWS_DEFAULT_REGION"
  value      = var.aws_default_region
  write_only = true
}

resource "spacelift_environment_variable" "aws_tf_var_aws_default_region" {
  context_id = spacelift_context.aws.id
  name       = "TF_VAR_aws_default_region"
  value      = var.aws_default_region
  write_only = false
}

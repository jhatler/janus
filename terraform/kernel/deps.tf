resource "spacelift_stack_dependency" "admin__auth" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "admin__crypto" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
}

resource "spacelift_stack_dependency" "crypto__auth" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "network__auth" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "network__admin" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
}

resource "spacelift_stack_dependency" "network__crypto" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
}

resource "spacelift_stack_dependency" "runners__crypto" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Runners"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
}

resource "spacelift_stack_dependency" "runners__network" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Runners"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
}

resource "spacelift_stack_dependency" "runners__webhooks" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Runners"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
}

resource "spacelift_stack_dependency" "runners__ssm" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Runners"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@SSM"].id
}

resource "spacelift_stack_dependency" "webhooks__auth" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "webhooks__admin" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
}

resource "spacelift_stack_dependency" "webhooks__crypto" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
}

resource "spacelift_stack_dependency" "webhooks__network" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
}

resource "spacelift_stack_dependency" "ssm__auth" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@SSM"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "ssm__admin" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@SSM"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
}

resource "spacelift_stack_dependency" "ssm__crypto" {
  stack_id            = spacelift_stack.workloads["${var.kernel_namespace}@SSM"].id
  depends_on_stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
}

resource "spacelift_stack_dependency_reference" "admin_s3_access_logging_kms_key_arn" {
  stack_dependency_id = spacelift_stack_dependency.admin__crypto.id
  output_name         = "TF_VAR_s3_access_logging_kms_key_arn"
  input_name          = "TF_VAR_s3_access_logging_kms_key_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "admin_apigateway_logs_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.admin__auth.id
  output_name         = "TF_VAR_apigateway_logs_role_arn"
  input_name          = "TF_VAR_apigateway_logs_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "network_s3_access_logs_bucket_id" {
  stack_dependency_id = spacelift_stack_dependency.network__admin.id
  output_name         = "TF_VAR_s3_access_logs_bucket_id"
  input_name          = "TF_VAR_s3_access_logs_bucket_id"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "network_vpc_flow_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.network__auth.id
  output_name         = "TF_VAR_vpc_flow_role_arn"
  input_name          = "TF_VAR_vpc_flow_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "network_vpc_flow_kms_key_arn" {
  stack_dependency_id = spacelift_stack_dependency.network__crypto.id
  output_name         = "TF_VAR_vpc_flow_kms_key_arn"
  input_name          = "TF_VAR_vpc_flow_kms_key_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "runners_runners_kms_key_arn" {
  stack_dependency_id = spacelift_stack_dependency.runners__crypto.id
  output_name         = "TF_VAR_runners_kms_key_arn"
  input_name          = "TF_VAR_runners_kms_key_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "runners_vpc_id" {
  stack_dependency_id = spacelift_stack_dependency.runners__network.id
  output_name         = "TF_VAR_vpc_id"
  input_name          = "TF_VAR_vpc_id"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "webhooks_github_webhook_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.webhooks__auth.id
  output_name         = "TF_VAR_github_webhook_role_arn"
  input_name          = "TF_VAR_github_webhook_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "webhooks_github_webhook_lambda_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.webhooks__auth.id
  output_name         = "TF_VAR_github_webhook_lambda_role_arn"
  input_name          = "TF_VAR_github_webhook_lambda_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "ssm_ssm_session_manager_kms_key_arn" {
  stack_dependency_id = spacelift_stack_dependency.ssm__crypto.id
  output_name         = "TF_VAR_ssm_session_manager_kms_key_arn"
  input_name          = "TF_VAR_ssm_session_manager_kms_key_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "ssm_s3_access_logs_bucket_id" {
  stack_dependency_id = spacelift_stack_dependency.ssm__admin.id
  output_name         = "TF_VAR_s3_access_logs_bucket_id"
  input_name          = "TF_VAR_s3_access_logs_bucket_id"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "runners_ssm_session_manager_bucket" {
  stack_dependency_id = spacelift_stack_dependency.runners__ssm.id
  output_name         = "TF_VAR_ssm_session_manager_bucket"
  input_name          = "TF_VAR_ssm_session_manager_bucket"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "crypto_runners_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.crypto__auth.id
  output_name         = "TF_VAR_runners_role_arn"
  input_name          = "TF_VAR_runners_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "crypto_runners_controlled_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.crypto__auth.id
  output_name         = "TF_VAR_runners_controlled_role_arn"
  input_name          = "TF_VAR_runners_controlled_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "crypto_github_webhook_lambda_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.crypto__auth.id
  output_name         = "TF_VAR_github_webhook_lambda_role_arn"
  input_name          = "TF_VAR_github_webhook_lambda_role_arn"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "crypto_ssm_agent_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.crypto__auth.id
  output_name         = "TF_VAR_ssm_agent_role_arn"
  input_name          = "TF_VAR_ssm_agent_role_arn"
  trigger_always      = true
}


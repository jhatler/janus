resource "spacelift_stack_dependency" "auth__control" {
  stack_id            = spacelift_stack.auth.id
  depends_on_stack_id = spacelift_stack.control.id
}

resource "spacelift_stack_dependency" "admin__auth" {
  stack_id            = spacelift_stack.children["Admin"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "network__auth" {
  stack_id            = spacelift_stack.children["Network"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "network__admin" {
  stack_id            = spacelift_stack.children["Network"].id
  depends_on_stack_id = spacelift_stack.children["Admin"].id
}

resource "spacelift_stack_dependency" "network__crypto" {
  stack_id            = spacelift_stack.children["Network"].id
  depends_on_stack_id = spacelift_stack.children["Crypto"].id
}

resource "spacelift_stack_dependency" "runners__crypto" {
  stack_id            = spacelift_stack.children["Runners"].id
  depends_on_stack_id = spacelift_stack.children["Crypto"].id
}

resource "spacelift_stack_dependency" "runners__network" {
  stack_id            = spacelift_stack.children["Runners"].id
  depends_on_stack_id = spacelift_stack.children["Network"].id
}

resource "spacelift_stack_dependency" "runners__webhooks" {
  stack_id            = spacelift_stack.children["Runners"].id
  depends_on_stack_id = spacelift_stack.children["Webhooks"].id
}

resource "spacelift_stack_dependency" "runners__ssm" {
  stack_id            = spacelift_stack.children["Runners"].id
  depends_on_stack_id = spacelift_stack.children["SSM"].id
}

resource "spacelift_stack_dependency" "webhooks__auth" {
  stack_id            = spacelift_stack.children["Webhooks"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "webhooks__admin" {
  stack_id            = spacelift_stack.children["Webhooks"].id
  depends_on_stack_id = spacelift_stack.children["Admin"].id
}

resource "spacelift_stack_dependency" "webhooks__crypto" {
  stack_id            = spacelift_stack.children["Webhooks"].id
  depends_on_stack_id = spacelift_stack.children["Crypto"].id
}

resource "spacelift_stack_dependency" "webhooks__network" {
  stack_id            = spacelift_stack.children["Webhooks"].id
  depends_on_stack_id = spacelift_stack.children["Network"].id
}

resource "spacelift_stack_dependency" "ssm__auth" {
  stack_id            = spacelift_stack.children["SSM"].id
  depends_on_stack_id = spacelift_stack.auth.id
}

resource "spacelift_stack_dependency" "ssm__admin" {
  stack_id            = spacelift_stack.children["SSM"].id
  depends_on_stack_id = spacelift_stack.children["Admin"].id
}

resource "spacelift_stack_dependency" "ssm__crypto" {
  stack_id            = spacelift_stack.children["SSM"].id
  depends_on_stack_id = spacelift_stack.children["Crypto"].id
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

resource "spacelift_stack_dependency_reference" "network_class_b_prefix" {
  stack_dependency_id = spacelift_stack_dependency.integration__control["Network"].id
  output_name         = "TF_VAR_class_b_prefix"
  input_name          = "TF_VAR_class_b_prefix"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "auth_stack_role_id" {
  stack_dependency_id = spacelift_stack_dependency.auth__control.id
  output_name         = "TF_VAR_stack_role_id"
  input_name          = "TF_VAR_stack_role_id"
  trigger_always      = true
}

resource "spacelift_stack_dependency_reference" "runners_runner_admin_pat" {
  stack_dependency_id = spacelift_stack_dependency.integration__control["Runners"].id
  output_name         = "TF_VAR_runners_admin_pat"
  input_name          = "TF_VAR_runners_admin_pat"
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

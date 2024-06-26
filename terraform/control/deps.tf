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

resource "spacelift_stack_dependency_reference" "network_s3_access_logs_bucket_id" {
  stack_dependency_id = spacelift_stack_dependency.network__admin.id
  output_name         = "TF_VAR_s3_access_logs_bucket_id"
  input_name          = "TF_VAR_s3_access_logs_bucket_id"
}

resource "spacelift_stack_dependency_reference" "network_vpc_flow_role_arn" {
  stack_dependency_id = spacelift_stack_dependency.network__auth.id
  output_name         = "TF_VAR_vpc_flow_role_arn"
  input_name          = "TF_VAR_vpc_flow_role_arn"
}

resource "spacelift_stack_dependency_reference" "network_vpc_flow_kms_key_arn" {
  stack_dependency_id = spacelift_stack_dependency.network__crypto.id
  output_name         = "TF_VAR_vpc_flow_kms_key_arn"
  input_name          = "TF_VAR_vpc_flow_kms_key_arn"
}

resource "spacelift_stack_dependency_reference" "network_class_b_prefix" {
  stack_dependency_id = spacelift_stack_dependency.integration__control["Network"].id
  output_name         = "TF_VAR_class_b_prefix"
  input_name          = "TF_VAR_class_b_prefix"
}

resource "spacelift_stack_dependency_reference" "auth_stack_role_id" {
  stack_dependency_id = spacelift_stack_dependency.auth__control.id
  output_name         = "TF_VAR_stack_role_id"
  input_name          = "TF_VAR_stack_role_id"
}

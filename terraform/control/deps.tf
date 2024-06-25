resource "spacelift_stack_dependency" "network__admin" {
  stack_id            = spacelift_stack.children["Network"].id
  depends_on_stack_id = spacelift_stack.children["Admin"].id
}

resource "spacelift_stack_dependency_reference" "network_s3_access_logs_bucket_id" {
  stack_dependency_id = spacelift_stack_dependency.network__admin.id
  output_name         = "s3_access_logs_bucket_id"
  input_name          = "s3_access_logs_bucket_id"
}

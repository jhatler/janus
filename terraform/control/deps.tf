resource "spacelift_stack_dependency" "hello_world__control" {
  stack_id            = spacelift_stack.children["Hello World"].id
  depends_on_stack_id = spacelift_stack.control.id
}

resource "spacelift_stack_dependency" "admin__control" {
  stack_id            = spacelift_stack.children["Admin"].id
  depends_on_stack_id = spacelift_stack.control.id
}

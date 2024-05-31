# Initial stack to test integrations
resource "spacelift_stack" "hello-world" {
  administrative    = true
  autodeploy        = true
  branch            = "main"
  description       = "Hello World Stack"
  name              = "Hello World"
  project_root      = "terraform/stacks/hello_world"
  repository        = "janus"
  terraform_version = "1.5.7"
}

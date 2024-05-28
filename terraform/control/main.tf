# Initial stack to test integrations
resource "spacelift_stack" "hello-world" {
  administrative    = false
  autodeploy        = true
  branch            = "main"
  description       = "Hello World Stack"
  name              = "Hello World"
  project_root      = "terraform/stacks/hello-world"
  repository        = "janus"
  terraform_version = "1.5.7"
}

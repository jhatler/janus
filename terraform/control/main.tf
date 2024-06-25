data "spacelift_account" "current" {}

# This is the control stack we are currently in
resource "spacelift_stack" "control" {
  administrative        = true
  autodeploy            = true
  protect_from_deletion = true

  github_action_deploy = false

  enable_well_known_secret_masking = true

  labels = [
    "admin",
    "aikido",
    "infracost"
  ]

  branch            = "main"
  description       = "Control Stack"
  name              = "Control"
  project_root      = "terraform/control"
  repository        = var.control_repository
  terraform_version = "1.5.7"
}

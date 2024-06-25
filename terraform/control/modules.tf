locals {
  modules_to_create = [
    {
      name         = "github-oidc"
      description  = "Configures GitHub access to IAM Role via OIDC"
      project_root = "terraform/modules/github_oidc"
    }
  ]
}

resource "spacelift_module" "github_oidc" {
  for_each = { for module in local.modules_to_create : module.name => module }

  terraform_provider = "aws"
  branch             = "main"
  repository         = var.control_repository

  labels = [
    "module"
  ]

  name         = each.key
  description  = each.value.description
  project_root = each.value.project_root
}

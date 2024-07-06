provider "spacelift" {}

provider "aws" {
  default_tags {
    tags = {
      Kernel     = "${var.kernel_owner}/${var.kernel_repository}/${var.kernel_branch}/${var.kernel_namespace}"
      Owner      = var.kernel_owner
      Repository = var.kernel_repository
      Branch     = var.kernel_branch
      Namespace  = var.kernel_namespace
      Registry   = var.kernel_registry
    }
  }
}

provider "github" {
  owner = var.kernel_owner
  token = var.kernel_token
}



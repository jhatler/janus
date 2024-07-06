# Simple Usage

This is a simple example of using the example module to create allow read-only EC2 access to a specific GitHub repository.

```hcl
module "github_oidc_simple_usage" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-s3-bucket/aws"
  providers = { aws = aws }

  github_owner      = var.kernel_owner
  github_repository = var.kernel_repository

  role_policies = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}
```

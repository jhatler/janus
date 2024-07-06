# Simple Usage

This is a simple example of using the this module.

```hcl
module "example" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-example/aws"
  providers = { aws = aws }
}
```

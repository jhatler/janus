# FOO Module


## Usage

```hcl
module "foo" {
  source = "${var.spacelift_registry_url}/foo/aws"


}
```

# Example Module

This module resources with the following features:

- Foo
- Bar

The resources also configured with these optional features:

- Bing
- Bang

## Usage

```hcl
module "example" {
  source = "${var.kernel_registry}/${var.kernel_namespace}-example/aws"
  providers = { aws = aws }
}
```

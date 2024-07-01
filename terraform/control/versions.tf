terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.14.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

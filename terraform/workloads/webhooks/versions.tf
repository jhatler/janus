terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }
}

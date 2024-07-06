variable "kernel_namespace" {
  type        = string
  description = "The namespace for the kernel and all resources operated by it."
  sensitive   = false
}

variable "kernel_token" {
  type        = string
  description = "The admin PAT for the kernel repository."
  sensitive   = true
}

variable "kernel_repository" {
  type        = string
  description = "The name of the kernel repository on GitHub."
  sensitive   = false
}

variable "kernel_owner" {
  type        = string
  description = "The owner of the kernel repository on GitHub."
  sensitive   = false
}

variable "kernel_branch" {
  type        = string
  description = "The branch to use on the kernel repository."
  sensitive   = false
}

variable "kernel_registry" {
  type        = string
  description = "The URL for the Terraform registry associated with the kernel."
  sensitive   = true
}

variable "aws_default_region" {
  type        = string
  description = "The default AWS region to use."
  sensitive   = true
}

variable "kernel_cidr_prefix" {
  type        = string
  description = "The CIDR prefix for the kernel VPC (e.g. 10.0)."
  sensitive   = true
}

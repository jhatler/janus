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

variable "aws_account_id" {
  type        = string
  description = "The AWS account ID in use."
  sensitive   = true
}

variable "spacelift_organization" {
  type        = string
  description = "The name of the Spacelift organization running the kernel."
  sensitive   = true
}

variable "spacelift_api_key_endpoint" {
  type        = string
  description = "The endpoint for your Spacelift organization."
  sensitive   = true
}

variable "spacelift_api_key_id" {
  type        = string
  description = "The ID of the API key for Spacelift."
  sensitive   = true
}

variable "spacelift_api_key_secret" {
  type        = string
  description = "The secret for the API key for Spacelift."
  sensitive   = true
}

variable "aikido_secret_key" {
  type        = string
  description = "The secret key for the Aikido access."
  sensitive   = true
}

variable "infracost_api_key" {
  type        = string
  description = "The API key for Infracost."
  sensitive   = true
}

variable "kernel_cidr_prefix" {
  type        = string
  description = "The CIDR prefix for the kernel VPC (e.g. 10.0)."
  sensitive   = true
}

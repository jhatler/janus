variable "kernel" {
  type        = string
  description = "The fully qualified path to the operating kernel."
  sensitive   = false
}

variable "kernel_namespace" {
  type        = string
  description = "The namespace of the operating kernel."
  sensitive   = false
}

variable "kernel_repository" {
  type        = string
  description = "The name of the operating kernel's repository on GitHub."
  sensitive   = false
}

variable "kernel_owner" {
  type        = string
  description = "The owner of the operating kernel's repository on GitHub."
  sensitive   = false
}

variable "kernel_branch" {
  type        = string
  description = "The branch in use from the operating kernel's repository."
  sensitive   = false
}

variable "kernel_registry" {
  type        = string
  description = "The URL for the Terraform registry in use by the operating kernel."
  sensitive   = true
}

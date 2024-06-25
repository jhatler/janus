variable "role_policies" {
  type        = list(string)
  description = "List of ARNs of IAM policies to attach to the OIDC role"
}

variable "github_owner" {
  type        = string
  description = "The owner of the GitHub repository to grant access to"
}

variable "github_repository" {
  type        = string
  description = "The name of the GitHub repository to grant access to"
}

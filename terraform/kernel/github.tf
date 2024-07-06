# tflint-ignore: terraform_unused_declarations
data "github_actions_public_key" "kernel" {
  repository = var.kernel_repository
}

import {
  to = github_actions_variable.aws_default_region
  id = "$KERNEL_REPOSITORY:AWS_DEFAULT_REGION"
}

resource "github_actions_variable" "aws_default_region" {
  repository    = var.kernel_repository
  variable_name = "AWS_DEFAULT_REGION"
  value         = var.aws_default_region
}

import {
  to = github_actions_variable.aws_account_id
  id = "$KERNEL_REPOSITORY:AWS_ACCOUNT_ID"
}

resource "github_actions_variable" "aws_account_id" {
  repository    = var.kernel_repository
  variable_name = "AWS_ACCOUNT_ID"
  value         = var.aws_account_id
}

import {
  to = github_actions_variable.kernel_cidr_prefix
  id = "$KERNEL_REPOSITORY:KERNEL_CIDR_PREFIX"
}

resource "github_actions_variable" "kernel_cidr_prefix" {
  repository    = var.kernel_repository
  variable_name = "KERNEL_CIDR_PREFIX"
  value         = var.kernel_cidr_prefix
}

import {
  to = github_actions_variable.kernel_online
  id = "$KERNEL_REPOSITORY:KERNEL_ONLINE"
}

resource "github_actions_variable" "kernel_online" {
  repository    = var.kernel_repository
  variable_name = "KERNEL_ONLINE"
  value         = "true"
}

import {
  to = github_actions_variable.kernel_namespace
  id = "$KERNEL_REPOSITORY:KERNEL_NAMESPACE"
}

resource "github_actions_variable" "kernel_namespace" {
  repository    = var.kernel_repository
  variable_name = "KERNEL_NAMESPACE"
  value         = var.kernel_namespace
}

import {
  to = github_actions_variable.spacelift_organization
  id = "$KERNEL_REPOSITORY:SPACELIFT_ORGANIZATION"
}

resource "github_actions_variable" "spacelift_organization" {
  repository    = var.kernel_repository
  variable_name = "SPACELIFT_ORGANIZATION"
  value         = var.spacelift_organization
}

resource "github_actions_secret" "aikido_secret_key" {
  repository      = var.kernel_repository
  secret_name     = "AIKIDO_SECRET_KEY"
  plaintext_value = var.aikido_secret_key
}

resource "github_actions_secret" "kernel_token" {
  repository      = var.kernel_repository
  secret_name     = "KERNEL_TOKEN"
  plaintext_value = var.kernel_token
}

resource "github_actions_secret" "infracost_api_key" {
  repository      = var.kernel_repository
  secret_name     = "INFRACOST_API_KEY"
  plaintext_value = var.infracost_api_key
}

resource "github_actions_secret" "spacelift_api_key_id" {
  repository      = var.kernel_repository
  secret_name     = "SPACELIFT_API_KEY_ID"
  plaintext_value = var.spacelift_api_key_id
}

resource "github_actions_secret" "spacelift_api_key_secret" {
  repository      = var.kernel_repository
  secret_name     = "SPACELIFT_API_KEY_SECRET"
  plaintext_value = var.spacelift_api_key_secret
}

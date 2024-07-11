data "aws_caller_identity" "current" {}

locals {
  kernel_integration_name      = "${var.kernel_namespace}@Kernel"
  kernel_integration_role_name = "${var.kernel_namespace}@kernel"
  kernel_integration_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.kernel_namespace}/${local.kernel_integration_role_name}"

  auth_integration_name      = "${var.kernel_namespace}@Auth"
  auth_integration_role_name = "${var.kernel_namespace}@auth"
  auth_integration_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.kernel_namespace}/${local.auth_integration_role_name}"

  harness_integration_name      = "${var.kernel_namespace}@Harness"
  harness_integration_role_name = "${var.kernel_namespace}@harness"
  harness_integration_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.kernel_namespace}/${local.harness_integration_role_name}"

  kernel_modules_integration_name      = "${var.kernel_namespace}@Kernel Module"
  kernel_modules_integration_role_name = "${var.kernel_namespace}@kernel_module"
  kernel_modules_integration_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.kernel_namespace}/${local.kernel_modules_integration_role_name}"

  workloads_integration_name      = "${var.kernel_namespace}@Workloads"
  workloads_integration_role_name = "${var.kernel_namespace}@workloads"
  workloads_integration_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.kernel_namespace}/${local.workloads_integration_role_name}"

  kernel_modules_external_ids = tomap(merge(
    # more mappings can be added here if needed
    { for k, v in data.spacelift_aws_integration_attachment_external_id.kernel_modules : k => v.external_id },
  ))

  workloads_external_ids = tomap(merge(
    # more mappings can be added here if needed
    { for k, v in data.spacelift_aws_integration_attachment_external_id.workloads : k => v.external_id },
  ))
}

##
## Kernel Setup
##

data "aws_iam_policy_document" "kernel" {
  statement {
    sid    = "AllowSpacelift"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.spacelift_account.current.aws_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"
      values = [
        "${data.spacelift_account.current.name}@*@${var.kernel_namespace}atkernel@*"
      ]
    }
  }

  statement {
    sid    = "AllowGithub"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.kernel_owner}/${var.kernel_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "kernel" {
  name               = local.kernel_integration_role_name
  assume_role_policy = data.aws_iam_policy_document.kernel.json
  path               = "/${var.kernel_namespace}/"
}

resource "aws_iam_role_policy_attachment" "kernel" {
  # checkov:skip=CKV_AWS_274:The Kernel should have AdministratorAccess
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.kernel.name
}

resource "spacelift_aws_integration" "kernel" {
  name = local.kernel_integration_name

  role_arn                       = local.kernel_integration_role_arn
  generate_credentials_in_worker = false
}

##
## Harness Setup
##

data "aws_iam_policy_document" "harness" {
  statement {
    sid    = "AllowSpacelift"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.spacelift_account.current.aws_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"
      values = [
        "${data.spacelift_account.current.name}@*@${var.kernel_namespace}atharness@*"
      ]
    }
  }

  statement {
    sid    = "AllowGithub"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.kernel_owner}/${var.kernel_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "harness" {
  name               = local.harness_integration_role_name
  assume_role_policy = data.aws_iam_policy_document.harness.json
  path               = "/${var.kernel_namespace}/"
}

resource "aws_iam_role_policy_attachment" "harness" {
  # checkov:skip=CKV_AWS_274:The Test Harness needs to have AdministratorAccess to be self-contained
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.harness.name
}

resource "spacelift_aws_integration" "harness" {
  name = local.harness_integration_name

  role_arn                       = local.harness_integration_role_arn
  generate_credentials_in_worker = false
}

##
## Auth Setup
##

data "aws_iam_policy_document" "auth" {
  statement {
    sid    = "AllowSpacelift"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.spacelift_account.current.aws_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"
      values = [
        "${data.spacelift_account.current.name}@*@${var.kernel_namespace}atauth@*"
      ]
    }
  }

  statement {
    sid    = "AllowGithub"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.kernel_owner}/${var.kernel_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "auth" {
  name               = local.auth_integration_role_name
  assume_role_policy = data.aws_iam_policy_document.auth.json
  path               = "/${var.kernel_namespace}/"
}

resource "aws_iam_role_policy_attachment" "auth" {
  # checkov:skip=CKV_AWS_274:The auth should have AdministratorAccess
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.auth.name
}

resource "spacelift_aws_integration" "auth" {
  name = local.auth_integration_name

  role_arn                       = local.auth_integration_role_arn
  generate_credentials_in_worker = false
}

##
## Kernel Modules Setup
##

data "aws_iam_policy_document" "kernel_modules" {
  statement {
    sid    = "AllowSpacelift"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.spacelift_account.current.aws_account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = values(local.kernel_modules_external_ids)
    }
  }

  statement {
    sid    = "AllowGithub"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.kernel_owner}/${var.kernel_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "kernel_modules" {
  name               = local.kernel_modules_integration_role_name
  assume_role_policy = data.aws_iam_policy_document.kernel_modules.json
  path               = "/${var.kernel_namespace}/"
}

resource "aws_iam_role_policy_attachment" "kernel_modules" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.kernel_modules.name
}

resource "spacelift_aws_integration" "kernel_modules" {
  name = local.kernel_modules_integration_name

  role_arn                       = local.kernel_modules_integration_role_arn
  generate_credentials_in_worker = false
}

##
## Workloads Setup
##
resource "spacelift_aws_integration" "workloads" {
  name = local.workloads_integration_name

  # We need to set this manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.workloads_integration_role_arn
  generate_credentials_in_worker = false
}

data "aws_iam_policy_document" "workloads" {
  statement {
    sid    = "AllowSpacelift"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [data.spacelift_account.current.aws_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "sts:ExternalId"
      values   = values(local.workloads_external_ids)
    }
  }

  statement {
    sid    = "AllowGithub"
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.kernel_owner}/${var.kernel_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "workloads" {
  name               = local.workloads_integration_role_name
  assume_role_policy = data.aws_iam_policy_document.workloads.json
  path               = "/${var.kernel_namespace}/"
}

resource "aws_iam_role_policy_attachment" "workloads" {
  role       = aws_iam_role.workloads.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

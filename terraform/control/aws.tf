data "aws_caller_identity" "current" {}

locals {
  control_role_name = "spacelift-control"
  control_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.control_role_name}"
  auth_role_name    = "spacelift-auth"
  auth_role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.auth_role_name}"
  stack_role_name   = "spacelift-stacks"
  stack_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.stack_role_name}"
}

##
## Control Stack Setup
##

resource "spacelift_aws_integration" "control" {
  name = local.control_role_name

  # We need to set this manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.control_role_arn
  generate_credentials_in_worker = false
}

# The spacelift_aws_integration_attachment_external_id data source is
# used to help generate a trust policy for the integration
data "spacelift_aws_integration_attachment_external_id" "control" {
  integration_id = spacelift_aws_integration.control.id
  stack_id       = spacelift_stack.control.id
  read           = true
  write          = true
}

resource "aws_iam_role" "control" {
  name = local.control_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      jsondecode(data.spacelift_aws_integration_attachment_external_id.control.assume_role_policy_statement),
    ]
  })
}

resource "aws_iam_role_policy_attachment" "control" {
  # it may be possible to reduce this in the future
  # checkov:skip=CKV_AWS_274:Only the Control stack should have AdministratorAccess
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.control.name
}

resource "spacelift_aws_integration_attachment" "control" {
  integration_id = spacelift_aws_integration.control.id
  stack_id       = spacelift_stack.control.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    aws_iam_role.control
  ]
}

##
## Auth Stack Setup
##

resource "spacelift_aws_integration" "auth" {
  name = local.auth_role_name

  # We need to set this manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.auth_role_arn
  generate_credentials_in_worker = false
}

# The spacelift_aws_integration_attachment_external_id data source is
# used to help generate a trust policy for the integration
data "spacelift_aws_integration_attachment_external_id" "auth" {
  integration_id = spacelift_aws_integration.auth.id
  stack_id       = spacelift_stack.auth.id
  read           = true
  write          = true
}

resource "aws_iam_role" "auth" {
  name = local.auth_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        "Principal" = {
          "AWS" : data.spacelift_account.current.aws_account_id
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" = {
            # Allow the external ID for any of the stacks to assume our role
            "sts:ExternalId" = flatten([
              [for i in data.spacelift_aws_integration_attachment_external_id.control_modules : i.external_id],
              data.spacelift_aws_integration_attachment_external_id.auth.external_id
            ])
          }
        }
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "auth" {
  # it may be possible to reduce this in the future
  # checkov:skip=CKV_AWS_274:Only the Control stack should have AdministratorAccess
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.auth.name
}

resource "spacelift_aws_integration_attachment" "auth" {
  integration_id = spacelift_aws_integration.auth.id
  stack_id       = spacelift_stack.auth.id
  read           = true
  write          = true

  # The role needs to exist before we attach since we test role assumption during attachment.
  depends_on = [
    aws_iam_role.auth
  ]
}


##
## Child Stack Setup
##
resource "spacelift_aws_integration" "integration" {
  name = local.stack_role_name

  # We need to set this manually rather than referencing the role to avoid a circular dependency
  role_arn                       = local.stack_role_arn
  generate_credentials_in_worker = false
}

locals {
  integration_external_ids = tomap(merge(
    # more mappings can be added here if needed
    { for k, v in data.spacelift_aws_integration_attachment_external_id.integration : k => v.external_id },
  ))
}

resource "aws_iam_role" "integration" {
  name = local.stack_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        "Principal" = {
          "AWS" : data.spacelift_account.current.aws_account_id
        },
        "Action" = "sts:AssumeRole",
        "Condition" = {
          "StringEquals" = {
            # Allow the external ID for any of the stacks to assume our role
            "sts:ExternalId" = values(local.integration_external_ids)
          }
        }
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "integration" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role       = aws_iam_role.integration.name
}

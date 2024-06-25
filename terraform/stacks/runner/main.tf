data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_subnet" "dmz" {
  filter {
    name   = "tag:Name"
    values = ["DMZ A"]
  }
}

module "sts_github_oidc" {
  source = "./modules/sts_github_oidc"

  token_subject = "repo:${var.github_owner}/${var.github_repository}:*"

  role_policy_arns = [
    aws_iam_policy.gh_oidc_ec2.arn
  ]

  providers = {
    aws = aws.us-east-2
  }
}

module "runner_template_arm64" {
  source = "./modules/runner_template"

  name          = "runner-arm64"
  instance_type = "c7g.medium"

  image_id = data.aws_ami.runner_arm64.id
  key_name = var.key_name

  iam_instance_profile_name = aws_iam_instance_profile.runner.name

  security_groups = [
    aws_security_group.runner.id
  ]

  subnet_id = data.aws_subnet.dmz.id

  tags = {
    Name           = "runner-arm64"
    "auth.gh-oidc" = "true"
    "class"        = "runner"
  }

  providers = {
    aws = aws.us-east-2
  }
}


module "runner_template_amd64" {
  source = "./modules/runner_template"

  name          = "runner-amd64"
  instance_type = "c7a.medium"

  image_id = data.aws_ami.runner_amd64.id
  key_name = var.key_name

  cpu_credits = "unlimited"

  iam_instance_profile_name = aws_iam_instance_profile.runner.name

  security_groups = [
    aws_security_group.runner.id
  ]

  subnet_id = data.aws_subnet.dmz.id

  tags = {
    Name           = "runner-amd64"
    "auth.gh-oidc" = "true"
    "class"        = "runner"
  }

  providers = {
    aws = aws.us-east-2
  }
}

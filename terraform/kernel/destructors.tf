# resource "spacelift_stack_destructor" "kernel" {
#   depends_on = [
#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_aws_integration_attachment.kernel,
#     aws_iam_role.kernel,
#     aws_iam_role_policy_attachment.kernel
#   ]

#   stack_id = spacelift_stack.kernel.id
# }

# resource "spacelift_stack_destructor" "auth" {
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,

#     spacelift_stack_dependency.auth__kernel,
#     spacelift_stack_dependency_reference.auth_stack_role_id,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.auth,
#     aws_iam_role.auth,
#     aws_iam_role_policy_attachment.auth,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]

#   stack_id = spacelift_stack.auth.id
# }

# resource "spacelift_stack_destructor" "harness" {
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_aws_integration_attachment.harness,
#     aws_iam_role.harness,
#     aws_iam_role_policy_attachment.harness
#   ]

#   stack_id = spacelift_stack.harness.id
# }

# resource "spacelift_stack_destructor" "admin" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Admin"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Admin"],

#     spacelift_stack.auth,
#     spacelift_stack.workloads["${var.kernel_namespace}@Crypto"],

#     spacelift_stack_dependency.admin__auth,
#     spacelift_stack_dependency.admin__crypto,
#     spacelift_stack_dependency_reference.admin_s3_access_logging_kms_key_arn,
#     spacelift_stack_dependency_reference.admin_apigateway_logs_role_arn,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "crypto" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Crypto"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Crypto"],

#     spacelift_stack.auth,
#     spacelift_stack_dependency.crypto__auth,
#     spacelift_stack_dependency_reference.crypto_runners_role_arn,
#     spacelift_stack_dependency_reference.crypto_runners_controlled_role_arn,
#     spacelift_stack_dependency_reference.crypto_github_webhook_lambda_role_arn,
#     spacelift_stack_dependency_reference.crypto_ssm_agent_role_arn,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "network" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Network"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Network"],

#     spacelift_stack.kernel.auth,
#     spacelift_stack.workloads["${var.kernel_namespace}@Admin"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Crypto"],
#     spacelift_stack_dependency.network__auth,
#     spacelift_stack_dependency.network__admin,
#     spacelift_stack_dependency.network__crypto,

#     spacelift_stack_dependency_reference.network_s3_access_logs_bucket_id,
#     spacelift_stack_dependency_reference.network_vpc_flow_role_arn,
#     spacelift_stack_dependency_reference.network_vpc_flow_kms_key_arn,
#     spacelift_stack_dependency_reference.network_kernel_cidr_prefix,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "ecr" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@ECR"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@ECR"],

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "runners" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Runners"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Runners"],

#     spacelift_stack.kernel.auth,
#     spacelift_stack.workloads["${var.kernel_namespace}@Crypto"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Network"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"],
#     spacelift_stack.workloads["${var.kernel_namespace}@SSM"],
#     spacelift_stack_dependency.runners__auth,
#     spacelift_stack_dependency.runners__crypto,
#     spacelift_stack_dependency.runners__network,
#     spacelift_stack_dependency.runners__webhooks,
#     spacelift_stack_dependency.runners__ssm,

#     spacelift_stack_dependency_reference.runners_runners_kms_key_arn,
#     spacelift_stack_dependency_reference.runners_vpc_id,
#     spacelift_stack_dependency_reference.runners_ssm_session_manager_bucket,
#     spacelift_stack_dependency_reference.runners_runner_admin_pat,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "webhooks" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@Webhooks"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@Webhooks"],

#     spacelift_stack.kernel.auth,
#     spacelift_stack.workloads["${var.kernel_namespace}@Admin"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Crypto"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Network"],
#     spacelift_stack_dependency.webhooks__auth,
#     spacelift_stack_dependency.webhooks__admin,
#     spacelift_stack_dependency.webhooks__crypto,
#     spacelift_stack_dependency.webhooks__network,

#     spacelift_stack_dependency_reference.webhooks_github_webhook_role_arn,
#     spacelift_stack_dependency_reference.webhooks_github_webhook_lambda_role_arn,
#     spacelift_stack_dependency_reference.webhooks_github_token,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

# resource "spacelift_stack_destructor" "ssm" {
#   stack_id = spacelift_stack.workloads["${var.kernel_namespace}@SSM"].id
#   depends_on = [
#     spacelift_stack.kernel,
#     spacelift_aws_integration_attachment.kernel,
#     spacelift_stack_dependency.workloads__kernel["${var.kernel_namespace}@SSM"],

#     spacelift_stack.kernel.auth,
#     spacelift_stack.workloads["${var.kernel_namespace}@Admin"],
#     spacelift_stack.workloads["${var.kernel_namespace}@Crypto"],
#     spacelift_stack_dependency.webhooks__auth,
#     spacelift_stack_dependency.webhooks__admin,
#     spacelift_stack_dependency.webhooks__crypto,

#     spacelift_stack_dependency_reference.ssm_ssm_session_manager_kms_key_arn,
#     spacelift_stack_dependency_reference.ssm_s3_access_logs_bucket_id,

#     spacelift_context.kernel,
#     spacelift_environment_variable.kernel_kernel_namespace,
#     spacelift_environment_variable.kernel_kernel_token,
#     spacelift_environment_variable.kernel_kernel_repository,
#     spacelift_environment_variable.kernel_kernel_owner,
#     spacelift_environment_variable.kernel_kernel_branch,
#     spacelift_environment_variable.kernel_kernel_cidr_prefix,
#     spacelift_environment_variable.kernel_aws_default_region,
#     spacelift_environment_variable.kernel_aws_account_id,
#     spacelift_environment_variable.kernel_kernel_registry,
#     spacelift_environment_variable.kernel_spacelift_organization,
#     spacelift_environment_variable.kernel_spacelift_api_key_endpoint,
#     spacelift_environment_variable.kernel_spacelift_api_key_id,
#     spacelift_environment_variable.kernel_spacelift_api_key_secret,
#     spacelift_environment_variable.kernel_aikido_secret_key,
#     spacelift_environment_variable.kernel_infracost_api_key,

#     spacelift_context.aws,
#     spacelift_environment_variable.aws_aws_default_region,
#     spacelift_environment_variable.aws_tf_var_aws_default_region,

#     spacelift_context.infracost,
#     spacelift_environment_variable.infracost_infracost_api_key,

#     spacelift_context.workloads,
#     spacelift_environment_variable.workloads_kernel,
#     spacelift_environment_variable.workloads_kernel_namespace,
#     spacelift_environment_variable.workloads_kernel_token,
#     spacelift_environment_variable.workloads_kernel_repository,
#     spacelift_environment_variable.workloads_kernel_owner,
#     spacelift_environment_variable.workloads_kernel_branch,
#     spacelift_environment_variable.workloads_kernel_registry,
#     spacelift_environment_variable.workloads_kernel_cidr_prefix,

#     spacelift_aws_integration_attachment.workloads,
#     aws_iam_role.workloads,
#     aws_iam_role_policy_attachment.workloads,

#     spacelift_module.kernel_modules,
#     spacelift_aws_integration_attachment.kernel_modules,
#   ]
# }

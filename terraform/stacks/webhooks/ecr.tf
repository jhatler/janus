resource "aws_ecr_repository" "github_webhook" {
  # checkov:skip=CKV_AWS_136:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_163:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_51:This will be addressed in a future PR
  #ts:skip=AWS.AER.DP.MEDIUM.0026 This will be addressed in a future PR
  #ts:skip=AWS.AER.DP.MEDIUM.0058 This will be addressed in a future PR
  name = "github-webhook"
}

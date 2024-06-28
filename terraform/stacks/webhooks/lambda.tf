# /incoming Lambda Function
resource "aws_lambda_function" "github_webhook_incoming" {
  #ts:skip=AWS.LambdaFunction.Logging.0472 This will be addressed in a future PR
  #ts:skip=AWS.LambdaFunction.LM.MEDIUM.0063 This will be addressed in a future PR
  #ts:skip=AWS.LambdaFunction.Logging.0470 This will be addressed in a future PR
  # checkov:skip=CKV_AWS_50:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_272:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_115:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_117:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_116:This will be addressed in a future PR
  function_name = "github-webhook"
  role          = var.github_webhook_lambda_role_arn
  architectures = ["x86_64"]
  image_uri     = "${aws_ecr_repository.github_webhook.repository_url}@sha256:07d99e016e73e45cf41386fb838921c85a295527d4e396172411312c38e5fe9b"
  package_type  = "Image"
  timeout       = 300
  memory_size   = 256
  image_config {
    command = [
      "lambda_function.incoming"
    ]
  }
}

# Events from SQS
resource "aws_lambda_event_source_mapping" "github_webhook" {
  event_source_arn = aws_sqs_queue.github_webhook.arn
  function_name    = aws_lambda_function.github_webhook_incoming.arn
  scaling_config {
    maximum_concurrency = 10
  }
}

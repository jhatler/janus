## DynamoDB tables to store GitHub webhook events
resource "aws_dynamodb_table" "github_webhook" {
  # checkov:skip=CKV_AWS_119:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_28:This will be addressed in a future PR
  #ts:skip=AWS.DynamoDb.Logging.Medium.007 This will be addressed in a future PR
  #ts:skip=AWS.ADT.DP.MEDIUM.0025 This will be addressed in a future PR

  name         = "github-webhook"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "X-GitHub-Delivery"

  attribute {
    name = "X-GitHub-Delivery"
    type = "S"
  }
}
resource "aws_dynamodb_table" "github_webhook_counts" {
  # checkov:skip=CKV_AWS_119:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_28:This will be addressed in a future PR
  #ts:skip=AWS.DynamoDb.Logging.Medium.007 This will be addressed in a future PR
  #ts:skip=AWS.ADT.DP.MEDIUM.0025 This will be addressed in a future PR

  name         = "github-webhook-counts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_type"

  attribute {
    name = "event_type"
    type = "S"
  }
}

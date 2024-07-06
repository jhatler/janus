# Queue for incoming webhook events
resource "aws_sqs_queue" "github_webhook" {
  # checkov:skip=CKV_AWS_27:This will be addressed in a future PR
  #ts:skip=AWS.SQS.NetworkSecurity.High.0570 This will be addressed in a future PR

  name                        = "github-webhook.fifo"
  fifo_queue                  = true
  visibility_timeout_seconds  = 300
  message_retention_seconds   = 345600
  max_message_size            = 262144
  receive_wait_time_seconds   = 0
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  content_based_deduplication = true
}

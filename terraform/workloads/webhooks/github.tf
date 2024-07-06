resource "github_repository_webhook" "kernel" {
  repository = var.kernel_repository

  configuration {
    url          = "${aws_api_gateway_stage.github_webhook_alpha.invoke_url}/incoming"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["workflow_job"]
}

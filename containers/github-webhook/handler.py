"""
Handles GitHub events.
"""

import logging

import boto3  # pylint: disable=import-error
import handlers


class GithubEventHandler:
    "Handle GitHub events."

    def __init__(self):
        self.logger = logging.getLogger()

    def log_to_dynamodb(self, event):
        "Log the event to DynamoDB."
        database = boto3.resource("dynamodb")
        table = database.Table("github-webhook")
        self.logger.debug("putting event to DynamoDB")
        table.put_item(Item=event.to_dict())

    def increment_counts(self, event):
        "Increment the event type count in DynamoDB."
        event_type = event.event_type()
        database = boto3.resource("dynamodb")
        table = database.Table("github-webhook-counts")

        count = 1

        self.logger.debug("trying to get event count from DynamoDB")
        response = table.get_item(Key={"event_type": event_type})
        if "Item" in response:
            self.logger.debug("found event count in DynamoDB")
            count += response["Item"]["count"]

        self.logger.debug("putting event count to DynamoDB")
        table.put_item(Item={"event_type": event_type, "count": count})

    def log_event(self, event, context):
        "Log the event to DynamoDB and increment the event type count."
        self.logger.debug("logging event to DynamoDB")

        self.logger.debug("event: %s", event.to_dict())
        self.logger.debug("context: %s", context)

        self.log_to_dynamodb(event)
        self.increment_counts(event)

    def handle(self, event, context):
        "Handle the GithubEvent."
        self.logger.debug("Checking the GitHub event type")
        event_type = event.event_type()
        self.logger.debug("Found GitHub event type: %s", event_type)

        if event_type == "workflow_job":
            self.logger.debug("found handler for workflow_job")
            handlers.workflow_job(event)
        else:
            self.log_event(event, context)

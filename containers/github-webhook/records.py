"""
Provides classes to represent records produced by this lambda.
"""

import base64
import copy
import json
import logging

import boto3  # pylint: disable=import-error


class IncomingData:
    "Encapsulate incoming data."

    def __init__(self, data):
        "Create deep copy of incoming data and encapsulate."
        self.data = copy.deepcopy(data)
        self.logger = logging.getLogger()

    def decode(self, key):
        "Decode key even if it is base64 and/or json encoded."
        self.logger.debug("decoding key: %s", key)
        s = self.data[key]
        self.logger.debug("value type: %s", type(s))

        # decode s if it is base64 encoded
        try:
            self.logger.debug("trying to decode base64: %s", s)
            s_str = base64.b64decode(s=s, validate=True)
        except ValueError as e:
            self.logger.debug("could not decode base64: %s", e)
            # assume s is a string and not base64 encoded
            s_str = self.data[key]

        # try to decode s as json
        try:
            self.logger.debug("trying to decode json: %s", s_str)
            return json.loads(s_str)
        except ValueError as e:
            self.logger.debug("could not decode json: %s", e)
            return s_str

    def __getitem__(self, key):
        "Return the value of the key."

        return self.data[key]


class SqsRecord(IncomingData):
    """Encapsulate an SQS record.

    Keys in the record:
        messageId -> str (uuid)
        receiptHandle -> str (base64)
        body -> str
        attributes -> dict
        messageAttributes -> dict
        md5OfBody -> str (hex)
        eventSource -> str
        eventSourceARN -> str
        awsRegion -> str

    Keys in attributes:
        ApproximateReceiveCount -> str (int)
        AWSTraceHeader -> str
        SentTimestamp -> str (int)
        SequenceNumber -> str (int)
        MessageGroupId -> str
        SenderId -> str
        MessageDeduplicationId -> str (hex)
        ApproximateFirstReceiveTimestamp -> str (int)
    """

    def delete(self):
        "Delete the record from the SQS queue."
        sqs = boto3.client("sqs")
        account = boto3.client("sts").get_caller_identity().get("Account")
        queue_url = f"https://sqs.{sqs.meta.region_name}.amazonaws.com/{account}/github-webhook.fifo"
        sqs.delete_message(QueueUrl=queue_url, ReceiptHandle=self.data["receiptHandle"])

    def __getitem__(self, key):
        "Return the value of the key."

        if key == "body":
            self.logger.debug("decoding body")
            return self.decode("body")

        return super().__getitem__(key)


class GithubEvent(IncomingData):
    "Encapsulate a GitHub event."

    def __init__(self, data):
        "Create deep copy of incoming data and encapsulate."
        super().__init__(data)
        self.logger.debug("decoding body")
        self.body = self.decode("body")

    def event_type(self):
        "Return the type of the event."
        return self.data["header"]["X-GitHub-Event"]

    def to_dict(self):
        "Return the event as a dictionary."
        ret = {}

        # add the params first, overriding from header, to querystring, to path
        for k in self.data["header"]:
            ret[k] = self.data["header"][k]
        for k in self.data["querystring"]:
            ret[k] = self.data["querystring"][k]
        for k in self.data["path"]:
            ret[k] = self.data["path"][k]

        # add the body, overriding the params
        ret.update(self.body)

        return ret

    def path(self):
        "Return the path of the event."
        return self.data["path"]

    def headers(self):
        "Return the headers of the event."
        return self.data["header"]

    def querystring(self):
        "Return the querystring of the event."
        return self.data["querystring"]

    def __getitem__(self, key):
        "Return the value of the key in the body."
        return self.body[key]

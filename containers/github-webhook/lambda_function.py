"""
Process webhook events from GitHub.
"""

import logging
import threading

from handler import GithubEventHandler
from records import GithubEvent, SqsRecord


def handle_record(record_raw, context):
    """
    Process a single record from the SQS event.
    """
    # set log level to DEBUG for now
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    # Create event handler for the records
    handler = GithubEventHandler()

    logger.debug("parsing SQS record")
    record = SqsRecord(record_raw)

    logger.debug("parsing GitHub event from SQS record")
    event = GithubEvent(record["body"])

    logger.debug("running handler on GitHub event from SQS record")
    handler.handle(event, context)

    logger.debug("deleting SQS record")
    record.delete()


def incoming(event, context):
    """Process incoming SQS records."""
    # set log level to DEBUG for now
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    threads = [
        threading.Thread(
            target=handle_record,
            args=(
                record_raw,
                context,
            ),
        )
        for record_raw in event["Records"]
    ]
    for thread in threads:
        logger.debug("starting thread")
        thread.start()
    for thread in threads:
        logger.debug("waiting for thread to rejoin us")
        thread.join()
        logger.debug("thread rejoined")

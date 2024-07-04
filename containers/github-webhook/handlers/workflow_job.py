"""
Handles pull request events.
"""

import logging
import sys

import workflows

logger = logging.getLogger()
logger.info("handling workflow_job event")


def workflow_job_queued(event):
    "Handle queued action for workflow_job events."
    labels = event["workflow_job"]["labels"]

    # Check if any of the labels begin with aws:ec2launchtemplate:
    ec2_launch_template_labels = [
        label for label in labels if label.startswith("aws:ec2launchtemplate:")
    ]

    if not ec2_launch_template_labels:
        return
    if len(ec2_launch_template_labels) > 1:
        logger.error("More than one ec2 launch template label found, ignoring")
        return

    template = ec2_launch_template_labels[0].split(":")[2]

    logger.info("workflow_job requesting ec2 launch template: %s", template)
    try:
        workflow = getattr(workflows, "launch_runner")
        if callable(workflow):
            workflow(template)  # pylint: disable=not-callable
        else:
            logger.error("workflow launch_runner is not callable")
            raise AttributeError
    except AttributeError:
        logger.error("no workflow found for launch_runner")


def workflow_job(event):
    "Handle workflow_job events."
    match event["action"]:
        case "queued":
            logger.debug("queued action on workflow_job event received")
            workflow_job_queued(event)
        case _:
            logger.debug("unhandled action on workflow_job event received")


sys.modules[__name__] = workflow_job  # type: ignore

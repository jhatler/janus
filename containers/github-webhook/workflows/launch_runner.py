"""
Ensure team assignment of pull request.
"""

import logging
import random
import sys
import time

import boto3  # pylint: disable=import-error


def launch_runner_instance_count():
    "Returns the number of running runner instances."
    logger = logging.getLogger()
    logger.info("getting runner instance count")

    ec2 = boto3.client("ec2")
    response = ec2.describe_instances(
        Filters=[
            {"Name": "tag:class", "Values": ["runner"]},
            {"Name": "instance-state-name", "Values": ["running", "pending"]},
        ]
    )

    count = len(response["Reservations"])
    logger.info("found %s runner instances", count)
    return count


def launch_runner(launch_template_name):
    "Launches a runner from the specified launch template."
    logger = logging.getLogger()
    logger.info("launching runner from launch template: %s", launch_template_name)

    # perform random exponential backoff until there are less than 64 instances
    retry_count = 0
    while launch_runner_instance_count() >= 64:
        if retry_count > 10:
            raise RuntimeError("too many retries waiting to launch instance")

        sleep_time = random.uniform(0, 2**retry_count)
        logger.info("sleeping for %s seconds", sleep_time)
        time.sleep(sleep_time)
        retry_count += 1

    ec2 = boto3.client("ec2")
    logger.info("Requesting instance launch.")
    response = ec2.run_instances(
        LaunchTemplate={"LaunchTemplateName": launch_template_name},
        MinCount=1,
        MaxCount=1,
    )
    logger.info("Instance launch request completed")

    # check if no instances were launched
    if not response["Instances"]:
        raise RuntimeError("no instances launched")

    instance_id = response["Instances"][0]["InstanceId"]
    logger.info("launched instance: %s", instance_id)


sys.modules[__name__] = launch_runner  # type: ignore

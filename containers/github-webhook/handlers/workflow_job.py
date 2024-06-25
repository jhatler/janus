"""
Handles pull request events.
"""

import logging
import sys

import workflows


def workflow_job(event):
    logger = logging.getLogger()
    logger.info('handling workflow_job event')

    if event['action'] == 'queued':
        logger.debug('workflow_job queued action received')
        labels = event['workflow_job']['labels']

        # Check if any of the labels begin with aws:ec2launchtemplate:
        ec2_launch_template_labels = [label for label in labels if label.startswith('aws:ec2launchtemplate:')]

        if not ec2_launch_template_labels:
            return
        if len(ec2_launch_template_labels) > 1:
            logger.error('More than one ec2 launch template label found, ignoring')
            return

        template = ec2_launch_template_labels[0].split(':')[2]
        logger.info(f'workflow_job requesting ec2 launch template: {template}')
        workflows.launch_runner(template)


sys.modules[__name__] = workflow_job

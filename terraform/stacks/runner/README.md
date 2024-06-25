# Launching Self-Hosted GitHub Actions Runners on AWS EC2

This directory contains a rudimentary set of scripts and configuration files to launch self-hosted GitHub Actions runners on AWS EC2 instances. The scripts are designed to be run on a system with the AWS CLI installed and configured.

## Prerequisites

- An AWS account
- The AWS CLI installed and configured
- A GitHub token with sufficient permissions to create runner registration tokens
  - See here for more info: [Create a registration token for a repository](https://docs.github.com/en/rest/actions/self-hosted-runners?apiVersion=2022-11-28#create-a-registration-token-for-a-repository)
- An SSH key pair for the EC2 instances
- The `jq` utility is installed

## First Time Usage

Begin by cloning this repository and navigating to the `contrib/ec2-actions-runners` directory.

### GitHub Configuration

Copy the example GitHub configuration file and fill in the missing values:

```bash
$ cp env/github.env.example env/github.env
$ cat env/github
export GITHUB_OWNER=jhatler
export GITHUB_REPO=janus
export GITHUB_TOKEN=
```

### AWS Configuration

Copy the example AWS configuration file and fill in the missing values:

```bash
$ cp env/aws.env.example env/aws.env
$ cat env/aws.env
export EC2_KEY_NAME=foo-key
export EC2_PROFILE_NAME=foo-runner-profile
export EC2_ROLE_NAME=foo-runner-role
export ENI_SECURITY_GROUP_NAME=foo-runner-sg
```

Next, copy the example runner configuration file and fill in the missing values:

```bash
$ cp runners/runner.env.example runners/foo-runner.env
$ cat runners/foo-runner.env
export AMI_IMAGE_ID=ami-0f30a9c3a48f3fa79
export AMI_ROOT_SNAPSHOT_ID=snap-041f985de00ba79d4
export EC2_KEY_NAME=foo@bar
export EC2_TYPE=t3.micro
```

You may add additional runner configurations to the `templates` directory this way.
Every file within it will be used to create a corresponding runner launch template.

Finally, source the AWS configuration file:

```bash
$ source env/aws.env
$
```

### Key Setup

Upload the public key of the SSH key pair to AWS:

```bash
$ aws ec2 import-key-pair --key-name "$EC2_KEY_NAME" --public-key-material file://path/to/public-key.pem
$
```

### EC2 Instance Profile Setup

Create a new EC2 instance profile with the necessary permissions:

```bash
$ # Create the role
$ aws iam create-role --role-name $EC2_ROLE_NAME --assume-role-policy-document file://conf/role-trust-policy.json
{
    "Role": {
        "Path": "/",
        "RoleName": "foo-runner-role",
        "RoleId": "AAABBBCCCDDDEEEFFFGGG",
        "Arn": "arn:aws:iam::112233445566:role/foo-runner-role",
        "CreateDate": "2024-06-02T07:39:06+00:00",
        "AssumeRolePolicyDocument": ...
    }
}
$ # Attach the necessary policies
$ aws iam attach-role-policy --role-name $EC2_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
$ aws iam attach-role-policy --role-name $EC2_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
$ # Create the instance profile
$ aws iam create-instance-profile --instance-profile-name $EC2_PROFILE_NAME
{
    "InstanceProfile": {
        "Path": "/",
        "InstanceProfileName": "foo-runner-profile",
        "InstanceProfileId": "TTTUUUVVVWWWXXXYYYZZZ",
        "Arn": "arn:aws:iam::112233445566:instance-profile/foo-runner-profile",
        "CreateDate": "2024-06-02T07:41:22+00:00",
        "Roles": []
    }
}
$ # Add the role to the instance profile
$ aws iam add-role-to-instance-profile --instance-profile-name $EC2_PROFILE_NAME --role-name $EC2_ROLE_NAME
```

### Security Group Setup

Create a new security group that allows SSH access from your IP address; replace the security group ID in the second command with the one created in the first command:

```bash
$ aws ec2 create-security-group --group-name $ENI_SECURITY_GROUP_NAME --description "Security group for GitHub Actions runners"
{
    "GroupId": "sg-AAAABBBBCCCCDDDDEEEE"
}

$ aws ec2 authorize-security-group-ingress --group-id sg-AAAABBBBCCCCDDDDEEEE --protocol tcp --port 22 --cidr $(curl ifconfig.me/ip)/32
{
    "Return": true,
    "SecurityGroupRules": [
        {
            ...
        }
    ]
}
```

### Create/Update Launch Templates

This step can be done as many times as you would like. If the launch templates already exist, new versions will be created and set as the default.

Create the launch templates:

```bash
$ ./scripts/update-launch-templates.sh
$
```

### Launch EC2 Instances

To launch an EC2 instance using a specific runner configuration, run the following command:

```bash
$ aws ec2 run-instances --launch-template 'LaunchTemplateName=foo-runner,Version=$Latest' --count 1
$
```

These will configure themselves as GitHub Actions runners and register with the GitHub repository specified in the GitHub configuration file.

## Subsequent Usage

Update the launch templates (if necessary):

```bash
$ ./scripts/update-launch-templates.sh
$
```

Launch EC2 instances as needed:

```bash
$ aws ec2 run-instances --launch-template 'LaunchTemplateName=foo-runner,Version=$Latest' --count 1
$
```

The configuration files will be sourced automatically by the scripts.

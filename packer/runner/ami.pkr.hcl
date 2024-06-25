packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

variable "source_ami_prefix" {
  type    = string
}

variable "source_ami_owner" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "aws_region" {
  type    = string
}

variable "iam_instance_profile" {
  type    = string
}

variable "ami_name" {
  type    = string
}

variable "runner_name" {
  type    = string
}

data "amazon-ami" "source" {
    filters = {
        virtualization-type = "hvm"
        name = var.source_ami_prefix
        root-device-type = "ebs"
    }
    owners = [var.source_ami_owner]
    most_recent = true
    region =  "${var.aws_region}"

}

source "amazon-ebs" "runner" {
  region =  "${var.aws_region}"
  instance_type =  "${var.instance_type}"

  ami_name =  "${var.ami_name} {{timestamp}}"

  source_ami =  data.amazon-ami.source.id
  ssh_username =  "ubuntu"

  iam_instance_profile =  "${var.iam_instance_profile}"

  user_data_file = "files/cloud-config.txt"

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 64
    volume_type = "gp3"
    delete_on_termination = true
  }

  run_tags = {
    "Name" = "Packer: ${var.ami_name} {{timestamp}}"
  }

  run_volume_tags = {
    "Name" = "Packer: ${var.ami_name} {{timestamp}}"
  }

  snapshot_tags = {
    "Name" = "${var.ami_name} {{timestamp}}"
  }

  tags = {
    "Name" = "${var.ami_name} {{timestamp}}"
    "auth.gh-oidc" = "true"
  }
}

build {
  sources = [
    "amazon-ebs.runner"
  ]

  provisioner "shell" {
    inline = [
      "sudo rm -rf /setup",
      "sudo mkdir /setup",
      "sudo chown ubuntu:ubuntu /setup"
    ]
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/setup"
  }

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'; cloud-init status --wait"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -i /setup/scripts/test.sh"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo -i /setup/scripts/clean.sh"
    ]
  }
}

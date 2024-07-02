packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "source_ami" {
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

variable "cloud_config" {
  type    = string
}

source "amazon-ebs" "ubuntu-cloud-images-test" {
  region =  "${var.aws_region}"
  instance_type =  "${var.instance_type}"

  ssh_timeout = "5m"

  ami_name =  "packer/test/${var.source_ami}/{{timestamp}}"
  source_ami =  "${var.source_ami}"
  ssh_username =  "ubuntu"

  skip_create_ami = true

  iam_instance_profile =  "${var.iam_instance_profile}"

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 8
    volume_type = "gp3"
    delete_on_termination = true
  }

  user_data_file = "files/${var.cloud_config}"

  run_tags = {
    "Name" = "Packer Test: ${var.source_ami}"
  }

  run_volume_tags = {
    "Name" = "Packer Test: ${var.source_ami}"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu-cloud-images-test"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /setup",
      "sudo chown ubuntu:ubuntu /setup"
    ]
  }

  provisioner "file" {
    source      = "files"
    destination = "/setup"
  }

  provisioner "file" {
    source      = "scripts"
    destination = "/setup"
  }

  provisioner "shell" {
    inline = [
      "sudo -i /setup/scripts/10-test-cloudimg.sh"
    ]
  }
}

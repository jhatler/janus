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

variable "ami_name" {
  type    = string
}

variable "boot_mode" {
  type    = string
}

variable "cloud_image_file" {
  type    = string
}

variable "ami_architecture" {
  type    = string
}

source "amazon-ebssurrogate" "ubuntu-cloud-images" {
  region =  "${var.aws_region}"
  instance_type =  "${var.instance_type}"

  force_deregister = true
  force_delete_snapshot = true

  ami_name =  "${var.ami_name}"

  source_ami =  "${var.source_ami}"
  ssh_username =  "ubuntu"

  iam_instance_profile =  "${var.iam_instance_profile}"

  boot_mode =  "${var.boot_mode}"

  ami_virtualization_type = "hvm"
  ami_architecture = "${var.ami_architecture}"
  ena_support = true

  user_data_file = "files/cloud-config.txt"

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 8
    volume_type = "gp3"
    delete_on_termination = true
    omit_from_artifact = true
  }

  launch_block_device_mappings {
    device_name = "/dev/sdf"
    volume_size = 8
    volume_type = "gp3"
    delete_on_termination = true
  }

  ami_root_device {
    source_device_name = "/dev/sdf"
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp3"
  }


  run_tags = {
    "Name" = "Packer: ${var.ami_name}"
  }

  run_volume_tags = {
    "Name" = "Packer: ${var.ami_name}"
  }

  snapshot_tags = {
    "Name" = "${var.ami_name}"
  }

  tags = {
    "Name" = "${var.ami_name}"
  }
}

build {
  sources = [
    "source.amazon-ebssurrogate.ubuntu-cloud-images"
  ]

  provisioner "shell" {
    inline = [
      "sudo mkdir -p /setup",
      "sudo chown ubuntu:ubuntu /setup"
    ]
  }

  provisioner "file" {
    source      = "${var.cloud_image_file}"
    destination = "/setup/cloud-image.img"
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
      "sudo -i /setup/scripts/00-build-cloudimg.sh ${var.boot_mode}"
    ]
  }
}

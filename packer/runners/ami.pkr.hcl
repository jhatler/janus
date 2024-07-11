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

variable "vpc_name" {
  type    = string
  default = "Kernel"
}

variable "subnet_name" {
  type    = string
  default = "DMZ A"
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
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

  associate_public_ip_address = var.associate_public_ip_address

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
  }

  vpc_filter {
    filters = {
      "tag:Name": var.vpc_name
    }
  }

  subnet_filter {
    filters = {
      "tag:Name": var.subnet_name
    }
    most_free = true
    random = false
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

  # ensure that the ansible apt module doesn't fail due to missing metadata
  # see ansible#79206 for more information
  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'; cloud-init status --wait",
      "sudo rm -rf /var/lib/apt/lists/*",
      "sudo touch -d '1970-01-01 0:00:00' /var/lib/apt/lists"
    ]
  }

  provisioner "ansible" {
    playbook_file = "../../ansible/runners/packer.yml"

    # use_proxy fails with the ansible provisioner in some cases
    use_proxy = false

    groups = [
      "tag_class_runner",
      "aws_ec2"
    ]
    extra_arguments = [
      "--extra-vars", "actions_runner_name=${var.runner_name}",
      "--extra-vars", "actions_runner_prevent_service_start=true",
      "--extra-vars", "containers_prevent_service_start=true",
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

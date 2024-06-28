data "aws_ami" "source" {
  filter {
    name   = "image-id"
    values = [var.image_id]
  }
}

resource "aws_launch_template" "runner" {
  name          = var.name
  key_name      = var.key_name
  image_id      = var.image_id
  instance_type = var.instance_type

  ebs_optimized                        = true
  disable_api_termination              = false
  disable_api_stop                     = false
  instance_initiated_shutdown_behavior = "terminate"

  user_data = base64encode(file("${path.module}/files/cloud-config.txt"))

  update_default_version = true

  tags = var.tags

  credit_specification {
    cpu_credits = var.cpu_credits != "" ? var.cpu_credits : null
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      snapshot_id           = tolist(data.aws_ami.source.block_device_mappings)[0].ebs.snapshot_id
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  monitoring {
    enabled = false
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
  }

  private_dns_name_options {
    hostname_type = "ip-name"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }


  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    device_index                = 0
    delete_on_termination       = true
    security_groups             = var.security_groups
    subnet_id                   = var.subnet_id
  }
}

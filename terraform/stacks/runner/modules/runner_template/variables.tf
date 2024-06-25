variable "name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "security_groups" {
  type = list(string)
}

variable "root_volume_size" {
  type    = number
  default = 64
}

variable "cpu_credits" {
  type    = string
  default = ""
}

variable "subnet_id" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

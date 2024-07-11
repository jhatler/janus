variable "name" {
  type        = string
  description = "The name of the launch template to create."
  sensitive   = false
}

variable "image_id" {
  type        = string
  description = "The ID of the AMI to use for the launch template."
  sensitive   = false
}

variable "iam_instance_profile_name" {
  type        = string
  description = "The name of the IAM instance profile to use for the launch template."
  sensitive   = true
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type to use for the launch template."
  sensitive   = false
}

variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair to use for the launch template."
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the launch template."
  sensitive   = true
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs to associate with the launch template."
  sensitive   = true
}

variable "root_volume_size" {
  type        = number
  description = "The size of the root volume in GiB."
  default     = 64
}

variable "cpu_credits" {
  type        = string
  description = "The credit option for CPU usage."
  default     = ""
  sensitive   = false
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in which to launch the instance."
  sensitive   = true
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Whether to associate a public IP address with the instance."
  sensitive   = false
}

data "aws_ami" "runner_amd64" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^runner-amd64 .*$"
}

data "aws_ami" "runner_arm64" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^runner-arm64 .*$"
}

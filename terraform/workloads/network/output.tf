output "TF_VAR_vpc_id" {
  value       = aws_vpc.kernel.id
  description = "The ID of the VPC."
  sensitive   = true
}

output "TF_VAR_vpc_nat_eip_address" {
  value       = aws_eip.nat.public_ip
  description = "The public IP address NAT traffic is routed through."
  sensitive   = true
}

output "TF_VAR_subnet_admin_id" {
  value       = aws_subnet.admin.id
  description = "The ID of the admin subnet."
  sensitive   = true
}

output "TF_VAR_subnet_admin_cidr_block" {
  value       = aws_subnet.admin.cidr_block
  description = "The CIDR block of the admin subnet."
  sensitive   = true
}

output "TF_VAR_subnet_edge_ids" {
  value       = aws_subnet.edge[*].id
  description = "The IDs of the public edge subnets."
  sensitive   = true
}

output "TF_VAR_subnet_edge_cidr_blocks" {
  value       = aws_subnet.edge[*].cidr_block
  description = "The CIDR blocks of the public edge subnets."
  sensitive   = true
}

output "TF_VAR_subnet_dmz_ids" {
  value       = aws_subnet.dmz[*].id
  description = "The IDs of the DMZ subnets."
  sensitive   = true
}

output "TF_VAR_subnet_dmz_cidr_blocks" {
  value       = aws_subnet.dmz[*].cidr_block
  description = "The CIDR blocks of the DMZ subnets."
  sensitive   = true
}

output "TF_VAR_subnet_internal_ids" {
  value       = aws_subnet.internal[*].id
  description = "The IDs of the internal subnets."
  sensitive   = true
}

output "TF_VAR_subnet_internal_cidr_blocks" {
  value       = aws_subnet.internal[*].cidr_block
  description = "The CIDR blocks of the internal subnets."
  sensitive   = true
}


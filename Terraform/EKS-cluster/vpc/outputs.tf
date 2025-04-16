# vpc/outputs.tf
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = aws_subnet.subnet_public[*].id
}

output "private_subnets" {
  description = "List of private subnets"
  value       = aws_subnet.subnet_private[*].id
}

output "eks_security_group" {
  description = "EKS security group"
  value       = aws_security_group.eks_sg.id
}

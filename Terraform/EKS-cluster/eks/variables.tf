# eks/variables.tf
variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_role_arn" {
  description = "ARN of the IAM role for EKS"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "eks_security_group" {
  description = "EKS security group ID"
  type        = string
}

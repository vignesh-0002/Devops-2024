# variables.tf

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_role_arn" {
  description = "IAM Role ARN for the EKS cluster"
  type        = string
}

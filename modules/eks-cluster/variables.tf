variable "vpc_id" {
  type        = string
  description = "VPC id in which eks cluster is to be created"
}

variable "eks_cluster_role_name" {
  type        = string
  default     = "eks_cluster_role"
  description = "Name of the role which will be used by eks cluster"
}

variable "esk_cluster_default_sg_name" {
  type        = string
  default     = "eks_cluster_defualt_sg"
  description = "Name of the security group which will be attached to eks cluster"
}

variable "eks_nodes_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids of the worker nodes, which allows worker nodes to communicate with eks cluster"
}

variable "existing_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Existing security group ids, eks cluster will allow connection from these security groups"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "Existing CIDR blocks, eks cluster will allow connection from these security groups"
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.24"
  description = "Version of the kubernetes that will be running in our cluster"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "Types of cluster logs that we want to export"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets where we want to launch our eks cluster"
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "EKS private API server endpoint is enabled"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = " EKS public API server endpoint is enabled"
}


variable "workers_security_group_count" {
  type        = number
  default     = 0
  description = "Toatl no of worker security groups"
}


# variable "bastion_host_role_arns" {
#   type        = list(string)
#   default     = []
#   description = "Bastian host roles arns"
# }

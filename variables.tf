# -----------------.
# Default variabels.
# -----------------.
variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "Default aws region"
}

# ----------------.
# Common variables.
# ----------------.
variable "eks_cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.24"
  description = "Version of the kubernetes that will be running in our cluster"
}


# ---------------------.
# EKS cluster variables.
# ---------------------.
variable "vpc_id" {
  type        = string
  description = "VPC id in which eks cluster is to be created"
}

variable "eks_cluser_tags" {
  type        = map(string)
  default     = null
  description = "Tags that will be attached to aws eks cluster"
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

# variable "eks_nodes_security_group_ids" {
#   type        = list(string)
#   default     = []
#   description = "Security group ids of the worker nodes, which allows worker nodes to communicate with eks cluster"
# }

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

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "Types of cluster logs that we want to export"
}

variable "eks_cluster_subnet_ids" {
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

variable "workers_role_arns" {
  type        = list(string)
  default     = []
  description = "eks worker nodes arn"
}


variable "bastion_host_role_arns" {
  type        = list(string)
  default     = []
  description = "Bastian host roles arns"
}

variable "logs_retention_in_days" {
  type        = number
  default     = 7
  description = "No of days up to which the aws eks cluster logs are kept"
}

variable "skip_destroy" {
  type        = bool
  default     = false
  description = "Set to true if the log group (and any logs it may contain) to be deleted at destroy time"
}

variable "kms_key_id" {
  type        = string
  default     = "false"
  description = "Id of the KMS key if the eks logs needs to be encrypted"
}

variable "create_eks_log_group" {
  type        = number
  default     = 0
  description = "Indicate either to create eks log group or not"
}

# --------------------------.
# Eks worker nodes variables.
# --------------------------.
variable "eks_worker_node_role_name" {
  type        = string
  default     = "eks_worker_nodes_role"
  description = "Name of the role which will be attached to eks worker nodes"
}

variable "ec2_ami_image_id" {
  type        = string
  default     = ""
  description = "The EC2 image ID to launch"
}

variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "EC2 instance type.Available options are `ON_DEMAND` and `SPOT`"
}

variable "disk_size" {
  type        = number
  default     = 20
  description = "Capacity of the EBS volume that will be attached to the EC2 instances"
}

variable "force_update_version" {
  type        = bool
  default     = false
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
}


variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "Underlying EC2 instance types"
}

variable "node_group_name" {
  type        = string
  description = "Name of the underlying eks worker nodes group"
}

variable "eks_worker_subnet_ids" {
  type        = list(string)
  description = "Subnets where we want to launch eks worker nodes"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Mininum number instances in the auto scaling group"
}

variable "max_size" {
  type        = number
  default     = 3
  description = "Maxminum number instances in the auto scaling group"
}

variable "desired_size" {
  type        = number
  default     = 1
  description = "Desired number instances currently running in the auto scaling group"
  # [NOTE]: `desire_size` should be less than or equals to `max_size` and greater than or equals to `min_size`
}

variable "eks_worker_nodes_labels" {
  type        = map(string)
  default     = null
  description = "Labels that will be attached to the underlying EC2 instances"
}

variable "max_unavailable" {
  type        = number
  default     = 1
  description = "Version of the kubernetes that will be running in our cluster"
}

variable "eks_worker_nodes_tags" {
  type        = map(string)
  default     = null
  description = "Tags that will be attached to aws eks worker nodes, EC2 instances"
}

variable "existing_worker_role_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of policy ARNs that will be attached to the workers default role on creation"
}

variable "update_config" {
  type = object({
    max_unavailable            = number
    max_unavailable_percentage = string
  })

  default     = null
  description = "The update_config specifications of the node groups"
}

variable "ec2_ssh_key" {
  type        = string
  default     = ""
  description = "SSH which is required to run ssh to the worker nodes"
}

variable "source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "List of security group ids which can ssh to the worker nodes"
}

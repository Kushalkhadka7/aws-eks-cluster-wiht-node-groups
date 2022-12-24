variable "cluster_name" {
  type        = string
  description = "Cluster name in which these worker nodes will be attached"
}

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
  default     = ["t2.micro"]
  description = "Underlying EC2 instance types"
}

variable "node_group_name" {
  type        = string
  description = "Name of the underlying eks worker nodes group"
}

variable "aws_subnets_ids" {
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

variable "kubernetes_version" {
  type        = string
  default     = "1.24"
  description = "Version of the kubernetes that will be running in our cluster"
}

variable "max_unavailable" {
  type        = number
  default     = 1
  description = "Version of the kubernetes that will be running in our cluster"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags that will be attached to aws eks worker nodes, EC2 instances"
}

variable "existing_worker_role_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of policy ARNs that will be attached to the workers default role on creation"
}

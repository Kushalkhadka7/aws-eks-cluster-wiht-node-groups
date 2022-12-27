output "node_group_arn" {
  value       = join("", aws_eks_node_group.this.*.arn)
  description = "EKS worker nodes group arn"
}

output "node_group_id" {
  value       = join("", aws_eks_node_group.this.*.id)
  description = "EKS worker nodes group arn"
}

output "worker_node_resources" {
  value       = aws_eks_node_group.this
  description = "EKS worker nodes group resources"
}

output "status" {
  value       = join("", aws_eks_node_group.this.*.status)
  description = "EKS worker nodes group status"
}


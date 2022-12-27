# ------------------.
# Eks cluster output.
# ------------------.
output "eks_cluster_security_group_id" {
  value       = module.eks_cluster.security_group_id
  description = "Security group id, which is attached to the eks cluster"
}

output "security_group_arn" {
  value       = module.eks_cluster.security_group_arn
  description = "Security group ARN, which is attached to the eks cluster"
}

output "security_group_name" {
  value       = module.eks_cluster.security_group_name
  description = "Security group name, which is attached to the eks cluster"
}

output "eks_cluster_id" {
  value       = module.eks_cluster.eks_cluster_id
  description = "EKS cluster id"
}

output "eks_cluster_arn" {
  value       = module.eks_cluster.eks_cluster_arn
  description = "EKS cluster ARN"
}

output "eks_cluster_endpoint" {
  value       = module.eks_cluster.eks_cluster_endpoint
  description = "Eks cluster endpoint"
}

output "eks_cluster_certificate_authority_data" {
  value       = module.eks_cluster.eks_cluster_certificate_authority_data
  description = "EKS cluster certificate"
}

output "cluster_name" {
  value       = module.eks_cluster.eks_cluster_name
  description = "EkS cluster name"
}

# -----------------------.
# Eks worker nodes output.
# -----------------------.
output "node_group_arn" {
  value       = module.eks_worker_nodes.node_group_arn
  description = "EKS worker nodes group arn"
}

output "node_group_id" {
  value       = module.eks_worker_nodes.node_group_id
  description = "EKS worker nodes group id"
}

output "worker_node_resources" {
  value       = module.eks_worker_nodes.worker_node_resources
  description = "EKS worker nodes group resources"
}

output "status" {
  value       = module.eks_worker_nodes.status
  description = "EKS worker nodes group status"
}

output "eks_cluster_name" {
  value       = module.eks_cluster.eks_cluster_name
  description = "Name of the created eks cluster"
}

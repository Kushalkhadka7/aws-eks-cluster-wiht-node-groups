output "security_group_id" {
  value       = join("", aws_security_group.eks_cluster_default_sg.*.id)
  description = "Security group id, which is attached to the eks cluster"
}

output "security_group_arn" {
  value       = join("", aws_security_group.eks_cluster_default_sg.*.arn)
  description = "Security group ARN, which is attached to the eks cluster"
}

output "security_group_name" {
  value       = join("", aws_security_group.eks_cluster_default_sg.*.name)
  description = "Security group name, which is attached to the eks cluster"
}

output "eks_cluster_id" {
  value       = join("", aws_eks_cluster.this.*.id)
  description = "EKS cluster id"
}

output "eks_cluster_arn" {
  value       = join("", aws_eks_cluster.this.*.arn)
  description = "EKS cluster ARN"
}

output "eks_cluster_endpoint" {
  value       = join("", aws_eks_cluster.this.*.endpoint)
  description = "Eks cluster endpoint"
}

output "eks_cluster_certificate_authority_data" {
  value       = local.certificate_authority_data
  description = "EKS cluster certificate"
}

output "eks_cluster_name" {
  value       = var.eks_cluster_name
  description = "Name of the created eks cluster"
}

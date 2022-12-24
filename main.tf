module "eks_cluster" {
  source = "./modules/eks-cluster"

  vpc_id                      = var.vpc_id
  eks_cluster_name            = var.eks_cluster_name
  eks_cluster_role_name       = var.eks_cluster_name
  kubernetes_version          = var.kubernetes_version
  subnet_ids                  = var.eks_cluster_subnet_ids
  endpoint_public_access      = var.endpoint_public_access
  endpoint_private_access     = var.endpoint_private_access
  enabled_cluster_log_types   = var.enabled_cluster_log_types
  esk_cluster_default_sg_name = var.esk_cluster_default_sg_name
}

module "eks_worker_nodes" {
  source = "./modules/eks-worker-nodes"

  # Worker nodes variables.
  cluster_name              = module.eks_cluster.eks_cluster_name
  eks_worker_node_role_name = var.eks_worker_node_role_name
  ec2_ami_image_id          = var.ec2_ami_image_id
  node_group_name           = var.node_group_name
  aws_subnets_ids           = var.eks_worker_subnet_ids
  eks_worker_nodes_labels   = var.eks_worker_nodes_labels

  tags = {
    "Name" : "eks-worker-nodes"
  }
}

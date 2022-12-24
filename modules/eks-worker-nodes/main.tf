locals {
  additional_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# Create iam role with assume role policy attached to it.
resource "aws_iam_role" "eks_worker_nodes_role" {
  name = var.eks_worker_node_role_name

  # Terraform's "jsonencode" function converts a terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge({
    "Name" = "eks-worker-nodes-role"
  }, local.additional_tags)
}

# Attach worker node policy to the eks cluster worker nodes.
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  count      = 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = join("", aws_iam_role.eks_worker_nodes_role.*.name)
}

# Attach CNI policy to the eks cluster worker nodes.
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  count      = 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = join("", aws_iam_role.eks_worker_nodes_role.*.name)
}

# Attach policy so that the worker nodes can fetch the images from ecr.
# Read only policy, worker nodes won't be able to modify the images in ecr.
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  count      = 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = join("", aws_iam_role.eks_worker_nodes_role.*.name)
}

# Attach existing policies to the eks worker role if exits any.
resource "aws_iam_role_policy_attachment" "existing_policies_arn" {
  count = length(var.existing_worker_role_policy_arns)

  role       = join("", aws_iam_role.eks_worker_nodes_role.*.name)
  policy_arn = length(var.existing_worker_role_policy_arns) > 0 ? var.existing_worker_role_policy_arns[count.index] : null
}


resource "aws_eks_node_group" "this" {
  count        = 1
  cluster_name = var.cluster_name

  ami_type             = var.ec2_ami_image_id
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types


  node_group_name = var.node_group_name
  node_role_arn   = join("", aws_iam_role.eks_worker_nodes_role.*.arn)

  subnet_ids = var.aws_subnets_ids

  scaling_config {
    max_size     = var.max_size
    min_size     = var.min_size
    desired_size = var.desired_size
  }

  labels = var.eks_worker_nodes_labels

  version = var.kubernetes_version

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  tags = merge(var.tags, local.additional_tags)
}

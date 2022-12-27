locals {
  certificate_authority_data_list          = coalescelist(aws_eks_cluster.this.*.certificate_authority, [[{ data : "" }]])
  certificate_authority_data_list_internal = local.certificate_authority_data_list[0]
  certificate_authority_data_map           = local.certificate_authority_data_list_internal[0]
  certificate_authority_data               = local.certificate_authority_data_map["data"]

  eks_log_group_name = "/aws/eks/${var.eks_cluster_name}/cluster"
}

# Create an iam policy document to let eks cluster to assume role.
# The assume_role_policy is very similar to but slightly different than a standard IAM policy 
# and cannot use an aws_iam_policy resource. 
# However, it can use an aws_iam_policy_document data source. 
# See the example https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "assume_role" {
  count = 1

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}


# Create a default IAM role with assume role policy attached.
resource "aws_iam_role" "cluster_role" {
  count              = 1
  name               = var.eks_cluster_role_name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)

  tags = merge({
    "Name" = "eks-cluster-role"
  }, var.tags, var.additional_cluster_tags)
}

# Attach managed eks cluster policy to the IAM role.
# This policy allow eks cluster to create and destory aws resources.
# It is recommended to use IAM for serivce account instead of this.
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = join("", aws_iam_role.cluster_role.*.name)
}

# Attach managed eks service policy to the IAM role.
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  count      = 1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = join("", aws_iam_role.cluster_role.*.name)
}

# Creates default security group for the eks cluster.
# By default it will allow all the egress traffic.
# Additionally the egress rule can be defined separately by using
# `aws_security_group_rule `
resource "aws_security_group" "eks_cluster_default_sg" {
  count       = 1
  vpc_id      = var.vpc_id
  name        = var.esk_cluster_default_sg_name
  description = "Secutity group for the eks cluster"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outgoing traffic from the eks-cluster"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = merge({
    "Name" = "eks_cluster_defualt_sg"
    Vpc    = var.vpc_id
  }, var.tags, var.additional_cluster_tags)
}


# Create rule which allow the nodes to communicate with the eks cluster contorl plane.
# Attach this rule to eks_cluster_default_sg secirity group if only the node security grop id exists.
resource "aws_security_group_rule" "allow_nodes" {
  count                    = var.workers_security_group_count
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = var.eks_nodes_security_group_ids[count.index]
  security_group_id        = join("", aws_security_group.eks_cluster_default_sg.*.id)
  description              = "Allow connection from the eks worker nodes"
}

# Allow connection from specified CIDR.
# If we have some CIDR blocks which needs to be connected to the eks cluster, this rule allows that.
resource "aws_security_group_rule" "allow_cidr" {
  count             = length(var.allowed_cidr_blocks)
  description       = "Allow inbound traffic from CIDR blocks"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.eks_cluster_default_sg.*.id)
  type              = "ingress"
}

# Allow connection from other security group if exists any.
resource "aws_security_group_rule" "existing_security_groups" {
  count                    = length(var.existing_security_group_ids)
  description              = "Allow inbound traffic from existing Security Groups"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = var.existing_security_group_ids[count.index]
  security_group_id        = join("", aws_security_group.eks_cluster_default_sg.*.id)
  type                     = "ingress"
}

resource "aws_cloudwatch_log_group" "example" {
  count = var.create_eks_log_group
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = local.eks_log_group_name
  retention_in_days = var.logs_retention_in_days
  skip_destroy      = var.skip_destroy
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, var.additional_cluster_tags)
}

# Finally create the aws eks cluster.
# Attach above defined role to the cluster.
# Attach above defined security group to the cluster.
# Cluster shoud be on at least on public and one private subnet.
# `amazon_eks_cluster_policy` and `amazon_eks_service_policy` should be created
# before creating the eks cluster.
# Referecne: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
resource "aws_eks_cluster" "this" {
  count                     = 1
  name                      = var.eks_cluster_name
  role_arn                  = join("", aws_iam_role.cluster_role.*.arn)
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [join("", aws_security_group.eks_cluster_default_sg.*.id)]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy
  ]

  tags = merge({
    "Name" = "eks-cluster"
  }, var.tags, var.additional_cluster_tags)

}

# modules/eks/main.tf

resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = var.eks_cluster_role_arn
  version  = "1.29"            # changed from 1.29

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name    = "${var.project_name}-cluster"
    Project = var.project_name
  }

  depends_on = [var.eks_cluster_role_arn]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types  = ["t3.micro"]
  ami_type        = "AL2_x86_64" 

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 5
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Project = var.project_name
    "k8s.io/cluster-autoscaler/enabled"                         = "true"
    "k8s.io/cluster-autoscaler/${var.project_name}-cluster"     = "owned"
  }
}

# --- EKS Addons ---
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"
  depends_on   = [aws_eks_node_group.main]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
}
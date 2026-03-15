resource "aws_eks_cluster" "this" {
  name                      = "workshop-eks-cluster"
  role_arn                  = aws_iam_role.cluster.arn
  version                   = "1.32"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = data.aws_subnets.private.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "workshop-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

data "aws_iam_user" "evandromelos" {
  user_name = "evandromelos"
}

resource "aws_eks_access_entry" "evandromelos" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = data.aws_iam_user.evandromelos.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "evandromelos" {
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = data.aws_iam_user.evandromelos.arn

  depends_on = [
    aws_eks_access_entry.evandromelos,
  ]

  access_scope {
    type = "cluster"
  }
}

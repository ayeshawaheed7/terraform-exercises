module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.3"

  cluster_name = local.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # starting from EKS 1.23 CSI plugin is needed for volume provisioning.
  cluster_addons = {
    aws-ebs-csi-driver = {}
  }

  eks_managed_node_groups = {
    nodegroup = {
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # EBS CSI Driver policy
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }

      tags = {
         Name = "${var.env_prefix}-ng-nodes"
         environment = var.env_prefix
      }
    }
  }

  fargate_profiles = {
    profile = {
      name = "my-app-fargate-profile"
      selectors = [{
         namespace = "my-app"
      }]
    }
  }

  tags = {
    environment = var.env_prefix
    Terraform   = "true"
  }

  enable_cluster_creator_admin_permissions = true
}
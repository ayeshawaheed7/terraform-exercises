output "cluster_name" {
    value = local.cluster_name
    description = "Kubernetes Cluster Name"
}

output "cluster_id" {
    description = "Kubernetes Cluster Id"
    value = module.eks.cluster_id
}

output "cluster_endpoint" {
    description = "Endpoint for eks control plane"
    value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
    description = "Security group ids attached to the cluster control plane"
    value = module.eks.cluster_security_group_id
}

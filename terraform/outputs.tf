
#VPC outputs

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}


#EKS outputs

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "API endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
  sensitive   = true
}

# Useful Commands

output "connect_to_cluster" {
  description = "Run this command to connect kubectl to your cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
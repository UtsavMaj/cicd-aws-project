output "jenkins_instance_profile_name" { value = aws_iam_instance_profile.jenkins_profile.name }
output "eks_cluster_role_arn"          { value = aws_iam_role.eks_cluster_role.arn }
output "eks_node_role_arn"             { value = aws_iam_role.eks_node_role.arn }
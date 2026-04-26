# infrastructure/terraform/variables.tf
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging all resources"
  type        = string
  default     = "CICD-AWS"
}

variable "environment" {
  description = "Deployment environment (dev or prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
 
variable "eks_cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.29"
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t2.micro"    # ← change from t2.large to t2.micro
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "your_ip" {
  description = "Your local machine IP for SSH access (format: x.x.x.x/32)"
  type        = string
  default     = "103.197.112.132/32"  # REPLACE with your real IP before apply
}
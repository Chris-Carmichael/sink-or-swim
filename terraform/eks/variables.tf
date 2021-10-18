variable "solution_name" {
  description = "Name of the solution, used in several artifacts for naming consistency"
  type        = string
  default     = "swim"
}

variable "cluster_version" {
  description = "Version of Kubernetes you want to run"
  type        = string
  default     = "1.20"
}

variable "instance_type" {
  description = "Size or instance type for worker nodes"
  type        = string
  default     = "t2.medium"
}

variable "asg_max_size" {
  description = "Max number of worker nodes in autoscaling group"
  type        = number
  default     = 3
}

# https://cloud-images.ubuntu.com/aws-eks/
variable "worker_ami_name_filter" {
  description = "AMI name filter for Ubuntu EKS worker image"
  type        = string
  default     = "ubuntu-eks/k8s_1.21/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "worker_ami_owner_id" {
  description = "Owner ID for AMI"
  type        = string
  default     = "099720109477"
}

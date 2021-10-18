variable "solution_name" {
  description = "Name of the solution, used in several artifacts for naming consistency"
  type        = string
  default     = "swim"
}

variable "vpc_cidr" {
  description = "CIDR for the overall VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "private_cidr_1" {
  description = "CIDR for private subnet 1 of the VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_cidr_2" {
  description = "CIDR for private subnet 2 of the VPC"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_cidr_1" {
  description = "CIDR for public subnet 1 of the VPC"
  type        = string
  default     = "10.0.101.0/24"
}

variable "public_cidr_2" {
  description = "CIDR for public subnet 2 of the VPC"
  type        = string
  default     = "10.0.102.0/24"
}

variable "az_1" {
  description = "Availability Zone 1"
  type        = string
  default     = "us-west-2a"
}

variable "az_2" {
  description = "Availability Zone 2"
  type        = string
  default     = "us-west-2b"
}

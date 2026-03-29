variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "team" {
  description = "The team responsible for the deployment"
  type        = string
  default     = "Elite-Data-Engineers"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "production"
}

variable "project" {
  description = "The project owner"
  type        = string
  default     = "Federated-Engineers"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default     = "vpc-09a5fdb174ed7c060"
}

variable "subnet_id_public_a" {
  description = "The ID of the subnet"
  type        = string
  default     = "subnet-0613b8ccd258f4cca"
}

variable "subnet_id_public_b" {
  description = "The ID of the subnet"
  type        = string
  default     = "subnet-0af2d376a426b58bb"
}




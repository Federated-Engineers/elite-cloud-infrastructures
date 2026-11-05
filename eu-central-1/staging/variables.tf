variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "team" {
  description = "The team responsible for the deployment"
  type        = string
  default     = "elite"
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
  default     = "staging"
}

variable "project" {
  description = "The project owner"
  type        = string
  default     = "federated-engineers"
}

variable "emr_vpc_id" {
  description = "Shared EMR VPC, managed in production/emr_vpc.tf"
  type        = string
  default     = "vpc-0b79a13742eb5dd78"
}

variable "emr_subnet_ids" {
  description = "Shared EMR public subnets, managed in production/emr_vpc.tf"
  type        = list(string)
  default = [
    "subnet-02dea4ee39939e241", # elite-emr-public-a
    "subnet-00ca9b61fa08f7f1d", # elite-emr-public-b
    "subnet-007890019937ed2e9", # elite-emr-public-c
  ]
}

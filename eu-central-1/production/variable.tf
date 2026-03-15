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

variable "bucket-use-case" {
  description = "The nature of the project"
  type        = string
  default     = "alpen_sftp-server"
}

variable "service" {
  description = "The service using the bucket"
  type        = string
  default     = "transfer_family"
}

variable "versioning" {
  description = "versioning status for the S3 bucket"
  type        = string
  default     = "Disabled"
}














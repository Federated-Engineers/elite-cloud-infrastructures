variable "team" {
  description = "The team responsible for the deployment"
  type        = string
  default     = "Data-Platform-Team"
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
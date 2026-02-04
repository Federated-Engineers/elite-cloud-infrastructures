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
  description = "The project owner / organisation"
  type        = string
  default     = "federated-engineers"
}

variable "related_project" {
  description = "Related project or component (e.g., logs, data-lake)"
  type        = string
  default     = "s3"
}
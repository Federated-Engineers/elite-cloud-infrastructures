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

variable "production-vpc" {
  description = "Federated Engineers production VPC ID"
  type        = string
  default     = "vpc-09a5fdb174ed7c060"
}

variable "production-vpc-subnet-public-a" {
  description = "Federated Engineers production VPC public subnet a ID"
  type        = string
  default     = "subnet-0613b8ccd258f4cca"
}

variable "production-vpc-subnet-public-b" {
  description = "Federated Engineers production VPC public subnet b ID"
  type        = string
  default     = "subnet-0af2d376a426b58bb"
}

variable "snowflake_account" {
  description = "Snowflake account identifier used for dbt authentication"
  type        = string
  sensitive   = true
}

variable "snowflake_user" {
  description = "Snowflake username used by dbt in CI/CD pipelines"
  type        = string
  sensitive   = true
}

variable "snowflake_password" {
  description = "Snowflake password used by dbt in CI/CD pipelines"
  type        = string
  sensitive   = true
}

variable "snowflake_database" {
  description = "Target Snowflake database for dbt transformations"
  type        = string
}

variable "snowflake_warehouse" {
  description = "Snowflake warehouse used to execute dbt workloads"
  type        = string
}

variable "snowflake_schema" {
  description = "Snowflake schema where dbt models will be materialized"
  type        = string
}

variable "snowflake_role" {
  description = "Snowflake role assigned to the dbt execution user"
  type        = string
}

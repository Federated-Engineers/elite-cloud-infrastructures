resource "aws_ssm_parameter" "snowflake_account" {
  name        = "/prod/elite/snowflake/account"
  description = "Snowflake account identifier"
  type        = "SecureString"
  value       = var.snowflake_account
}

resource "aws_ssm_parameter" "snowflake_user" {
  name        = "/prod/elite/snowflake/user"
  description = "Snowflake username"
  type        = "SecureString"
  value       = var.snowflake_user
}

resource "aws_ssm_parameter" "snowflake_password" {
  name        = "/prod/elite/snowflake/password"
  description = "Snowflake password"
  type        = "SecureString"
  value       = var.snowflake_password
}

resource "aws_ssm_parameter" "snowflake_database" {
  name        = "/prod/elite/snowflake/database"
  description = "Snowflake database"
  type        = "SecureString"
  value       = var.snowflake_database
}

resource "aws_ssm_parameter" "snowflake_warehouse" {
  name        = "/prod/elite/snowflake/warehouse"
  description = "Snowflake warehouse"
  type        = "SecureString"
  value       = var.snowflake_warehouse
}

resource "aws_ssm_parameter" "snowflake_schema" {
  name        = "/prod/elite/snowflake/schema"
  description = "Snowflake schema"
  type        = "SecureString"
  value       = var.snowflake_schema
}

resource "aws_ssm_parameter" "snowflake_role" {
  name        = "/prod/elite/snowflake/role"
  description = "Snowflake role"
  type        = "SecureString"
  value       = var.snowflake_role
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

provider "snowflake" {
  organization_name = "MIBPQEO"
  account_name      = "AE46648"
  user     = data.aws_ssm_parameter.elite_dbt_snowflake_user.value
  password = data.aws_ssm_parameter.elite_dbt_snowflake_password.value
  role     = data.aws_ssm_parameter.elite_dbt_snowflake_role.value
}

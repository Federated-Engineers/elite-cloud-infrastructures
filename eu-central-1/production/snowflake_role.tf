resource "snowflake_account_role" "elite_dbt_role" {
  name = "ELITE_DBT_ROLE"
}

resource "snowflake_grant_privileges_to_account_role" "angel_city_warehouse_usage" {
  privileges = [
    "USAGE",
    "OPERATE",
    "MONITOR"
  ]
  account_role_name = snowflake_account_role.elite_dbt_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.elite_dbt_wh.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "angel_city_database_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.elite_dbt_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.elite_dbt_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "angel_city_schema_usage" {
  privileges = [
    "USAGE",
    "CREATE TABLE",
    "CREATE VIEW",
    "CREATE STAGE"
  ]
  account_role_name = snowflake_account_role.elite_dbt_role.name
  on_schema {
    schema_name = "${snowflake_database.elite_dbt_db.name}.${snowflake_schema.dbt_madebayo.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "angel_city_health_schema_usage" {
  privileges = [
    "USAGE",
    "CREATE TABLE",
    "CREATE VIEW",
    "MODIFY"
  ]
  account_role_name = snowflake_account_role.elite_dbt_role.name
  on_schema {
    schema_name = "${snowflake_database.elite_dbt_db.name}.${snowflake_schema.prod.name}"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric      = 1
  numeric          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}


resource "aws_redshift_parameter_group" "spreekauf_parameter_group" {
  name        = "parameter-group-spreekauf-terraform"
  family      = "redshift-2.0"
  region      = "eu-central-1"
  description = "Custom parameter group for SpreeKauf Redshift cluster"

  parameter {
    name  = "require_ssl"
    value = "true"
  }

  parameter {
    name = "wlm_json_configuration"
    value = jsonencode([
      {
        name        = "etl_queue"
        priority    = "highest"
        auto_wlm    = true
        queue_type  = "auto"
        user_group  = ["etl_service_accounts"]
        user_role   = ["etl_role"]
        query_group = ["etl", "ingestion", "data_load", "load"]
      },

      {
        name                = "analyst_adhoc_queue"
        query_concurrency   = 5
        concurrency_scaling = "auto"
        auto_wlm            = true
        queue_type          = "auto"
        user_role           = ["analyst_role", "adhoc_role"]
        user_group          = ["analyst", "adhoc_users"]
        query_group         = ["adhoc", "analyst"]
      },

      {
        short_query_acceleration = true

      },

      {
        name       = "default_queue"
        auto_wlm   = true
        priority   = "lowest"
        queue_type = "auto"
        rules = [
          {
            rule_name = "kill_switch"
            predicate = [
              {
                metric_name = "query_temp_blocks_to_disk",
                operator    = ">",
                value       = 2097152
            }]
            action = "abort"
          },
          {
            rule_name = "priority_downgrade_cpu"
            predicate = [
              {
                metric_name = "query_cpu_usage_percent",
                operator    = ">",
                value       = 80
              },
              {
                metric_name = "query_execution_time",
                operator    = ">",
                value       = 1200
              }
            ]
            action = "hop"
          }
        ]
      }
    ])

  }

  parameter {
    name  = "max_concurrency_scaling_clusters"
    value = 5
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
}


# Create Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name        = "redshift-subnet-group"
  subnet_ids  = [aws_subnet.secure-production-private-a.id, aws_subnet.secure-production-private-b.id]
  description = "Redshift subnet group for cluster"
  tags = {
    Name = "redshift-subnet-group"
  }
  depends_on = [aws_vpc.secure-production]
}




resource "aws_redshift_cluster" "spreekauf_predictive_cluster" {
  cluster_identifier           = "spreekauf-predictive"
  node_type                    = "dc2.large"
  cluster_type                 = "multi-node"
  number_of_nodes              = 1
  database_name                = "predictive_db"
  master_username              = "admin"
  master_password              = random_password.password.result
  publicly_accessible          = true
  enhanced_vpc_routing         = true
  cluster_parameter_group_name = aws_redshift_parameter_group.spreekauf_parameter_group.name
  cluster_subnet_group_name    = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids       = [aws_security_group.secure-sg.id]

  skip_final_snapshot = true
  tags = {
    Name = "spreekaufRedshiftCluster"
  }
}

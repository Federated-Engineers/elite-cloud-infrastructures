# creatinng random password for Redshift master user and storing it securely in SSM Parameter Store with KMS encryption

resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric      = 1
  numeric          = true
  override_special = "!$%&*()-_=+[]{}<>:?"
}

# Create KMS key for encrypting Redshift master password in SSM Parameter Store
resource "aws_kms_key" "redshift_predictive" {
  description             = "KMS key for Redshift SSM parameters"
  deletion_window_in_days = 7
  enable_key_rotation     = true # Rotate the key annually — best practice
}

# Create an alias for the KMS key to make it easier to reference
resource "aws_kms_alias" "redshift" {
  name          = "alias/redshift-predictive-ssm"
  target_key_id = aws_kms_key.redshift_predictive.key_id
}

# Store the Redshift master password securely in SSM Parameter Store using the KMS key for encryption
resource "aws_ssm_parameter" "redshift_master_password" {
  name        = "/prod/redshift-predictive/master-password"
  description = "This is the master password for SpreeKauf Redshift cluster"
  type        = "SecureString"
  value       = random_password.password.result
  key_id      = aws_kms_key.redshift_predictive.arn
}

# Store the Redshift master username securely in SSM Parameter Store using the KMS key for encryption
resource "aws_ssm_parameter" "redshift_master_username" {
  name        = "/prod/redshift-predictive/master-username"
  description = "This is the master username for SpreeKauf Redshift cluster"
  type        = "String"
  value       = "redshift_admin_user"
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


data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "public_a" {
  id = var.subnet_id_public_a
}

data "aws_subnet" "public_b" {
  id = var.subnet_id_public_b
}


# Create Redshift Subnet Group
resource "aws_redshift_subnet_group" "spreekauf_predictive" {
  name        = "spreekauf-predictive-subnet-group"
  description = "Subnet group for SpreeKauf predictive Redshift cluster"

  subnet_ids = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id
  ]
  depends_on = [data.aws_vpc.selected]

  tags = {
    Name        = "spreekauf-predictive-subnet-group"
    Environment = "Dev"
  }
}


# security group for the redshift cluster
resource "aws_security_group" "redshift_sg_predictive" {
  name        = "redshift-sg-predictive"
  description = "Security group for Redshift cluster"
  vpc_id      = data.aws_vpc.selected.id
  tags = {
    Name        = "redshift-sg-predictive"
    Environment = "Dev"
  }
}

# Ingress rules for redshift security group
resource "aws_security_group_rule" "sg_ingress_https" {
  security_group_id = aws_security_group.redshift_sg_predictive.id
  type              = "ingress"
  description       = "Allow HTTPS traffic from https, http,SQL,RDS,ssh   block"
  from_port         = [443, 80, 5439, 543, 22]
  to_port           = [443, 80, 5439, 5432, 22]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egress rules for redshift security group
resource "aws_security_group_rule" "sg_egress_all" {
  security_group_id = aws_security_group.redshift_sg_predictive.id
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}



resource "aws_redshift_cluster" "spreekauf_predictive_cluster" {
  cluster_identifier           = "spreekauf-predictive"
  node_type                    = "ra3.large"
  cluster_type                 = "multi-node"
  number_of_nodes              = 2
  database_name                = "spreekauf_database"
  master_username              = data.aws_ssm_parameter.redshift_master_username.value
  master_password              = data.aws_ssm_parameter.redshift_master_password.value
  publicly_accessible          = true
  enhanced_vpc_routing         = true
  cluster_parameter_group_name = aws_redshift_parameter_group.spreekauf_parameter_group.name
  cluster_subnet_group_name    = aws_redshift_subnet_group.spreekauf_predictive.name
  vpc_security_group_ids       = [aws_security_group.redshift_sg_predictive.id]

  skip_final_snapshot = false
  tags                = merge(local.common_tags, { Name = "spreekauf-redshift-cluster" })
}

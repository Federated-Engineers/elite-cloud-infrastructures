resource "random_password" "password" {
  length      = 16
  min_numeric = 1
}

resource "aws_ssm_parameter" "redshift_master_password" {
  name        = "/production/elite/redshift/SpreeKauf/master-password"
  description = "This is the master password for SpreeKauf Redshift cluster"
  type        = "SecureString"
  value       = random_password.password.result
}


data "aws_ssm_parameter" "redshift_master_username" {
  name = "/production/elite/redshift-SpreeKauf/master-username"
}


resource "aws_redshift_parameter_group" "spreekauf_parameter_group" {
  name        = "parameter-group-spreekauf-terraform"
  family      = "redshift-2.0"
  region      = "eu-central-1"
  description = "Custom parameter group for SpreeKauf Redshift cluster"

  parameter {
    name = "wlm_json_configuration"
    value = jsonencode([
      {
        name       = "ETL queue"
        priority   = "highest"
        auto_wlm   = true
        queue_type = "auto"
        user_group = ["etl"]
      },

      {
        name                = "bi queue"
        priority            = "high"
        concurrency_scaling = "auto"
        auto_wlm            = true
        queue_type          = "auto"
        user_group          = ["bi"]
      },

      {
        name                = "Analyst/Ad-Hoc queue"
        priority            = "high"
        concurrency_scaling = "auto"
        auto_wlm            = true
        queue_type          = "auto"
        user_group          = ["analyst_team"]
        rules = [
          {
            rule_name = "blocks_read_query"
            predicate = [
              {
                metric_name = "query_blocks_read",
                operator    = ">",
                value       = 5000
              }
            ]
            action = "log"
          }
        ]
      },

      {
        name                     = "Short Query Acceleration"
        short_query_acceleration = true
      },

      {
        name       = "High Scan Query Queue"
        auto_wlm   = true
        priority   = "Normal"
        queue_type = "auto"
        rules = [
          {
            rule_name = "kill_switch"
            predicate = [
              {
                metric_name = "query_blocks_read",
                operator    = ">",
                value       = 1048575
            }]
            action = "abort"
        }]
      },


      {
        name       = "High CPU Usage and Time Queue"
        auto_wlm   = true
        priority   = "low"
        queue_type = "auto"
        rules = [
          {
            rule_name = "priority_downgrade_cpu"
            predicate = [
              {
                metric_name = "query_cpu_usage_percent",
                operator    = ">",
                value       = 80
              },
              {
                metric_name = "query_cpu_time",
                operator    = ">",
                value       = 1200
              },

            ]
            action = "change_query_priority",
            value  = "lowest"
          }

        ]
      }
    ])

  }

}


data "aws_vpc" "federated_vpc" {
  id = var.production-vpc
}

data "aws_subnet" "federate_public_a" {
  vpc_id = data.aws_vpc.federated_vpc.id
  id     = var.production-vpc-subnet-public-a
}

data "aws_subnet" "federate_public_b" {
  vpc_id = data.aws_vpc.federated_vpc.id
  id     = var.production-vpc-subnet-public-b
}



resource "aws_redshift_subnet_group" "spreekauf_predictive" {
  name        = "spreekauf-predictive-subnet-group"
  description = "Subnet group for SpreeKauf predictive Redshift cluster"

  subnet_ids = [
    data.aws_subnet.federate_public_b.id,
    data.aws_subnet.federate_public_a.id
  ]
  tags = merge(local.common_tags)
}


resource "aws_security_group" "redshift_sg_predictive" {
  name        = "redshift-sg-predictive"
  description = "Security group for Redshift cluster"
  vpc_id      = data.aws_vpc.federated_vpc.id
  tags        = merge(local.common_tags)
}

resource "aws_security_group_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.redshift_sg_predictive.id
  type              = "ingress"
  description       = "Allow inbound traffic from VPC CIDR block"
  from_port         = 0
  to_port           = 5439
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

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
  cluster_type                 = "single-node"
  number_of_nodes              = 1
  database_name                = "spreekauf_database"
  master_username              = data.aws_ssm_parameter.redshift_master_username.value
  master_password              = aws_ssm_parameter.redshift_master_password.value
  cluster_parameter_group_name = aws_redshift_parameter_group.spreekauf_parameter_group.name
  cluster_subnet_group_name    = aws_redshift_subnet_group.spreekauf_predictive.name
  vpc_security_group_ids       = [aws_security_group.redshift_sg_predictive.id]

  skip_final_snapshot = false
  tags                = merge(local.common_tags, { client = "spreekauf" })
}

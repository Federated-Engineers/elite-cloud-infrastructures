resource "random_password" "password" {
  length           = 16
  min_numeric      = 1
}

resource "aws_ssm_parameter" "redshift_master_password" {
  name        = "/production/redshift-SpreeKauf/master-password"
  description = "This is the master password for SpreeKauf Redshift cluster"
  type        = "SecureString"
  value       = random_password.password.result
}

data "aws_ssm_parameter" "redshift_master_password" {
  name            = "/production/redshift-SpreeKauf/master-password"                       
}

# Store the Redshift master username securely in SSM Parameter Store using the KMS key for encryption
resource "aws_ssm_parameter" "redshift_master_username" {
  name        = "/production/redshift-SpreeKauf/master-username"
  description = "This is the master username for SpreeKauf Redshift cluster"
  type        = "String"
  value       = "redshift_admin_user"
}

data "aws_ssm_parameter" "redshift_master_username" {
  name = "/production/redshift-SpreeKauf/master-username"
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
        name        = "ETL queue"
        priority    = "highest"
        auto_wlm    = true
        queue_type  = "auto"
        query_group = ["ETL Team"]
      },

      {
        name                = "Analyst/Ad-Hoc queue"
        concurrency_scaling = "auto"
        auto_wlm            = true
        queue_type          = "auto"
        query_group         = ["Analyst Team", "Ad-Hoc Team"]
      },

      {
        name                    = "Short Query Acceleration"
        short_query_acceleration = true
      },

      {
        name       = "Query Monitoring Rules Queue"
        auto_wlm   = true
        priority   = "low"
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
                metric_name = "query_cpu_time",
                operator    = ">",
                value       = 1200
              },
                
            ]
            action = "change_query_priority",
            value =  "lowest"
            }
          
        ]
      }
    ])

  }

}


data "aws_vpc" "federated_vpc" {
  id = "vpc-09a5fdb174ed7c060"
}

data "aws_subnet" "federate_public_a" {
  vpc_id = data.aws_vpc.federated_vpc.id
  id = "subnet-0613b8ccd258f4cca"
}

data "aws_subnet" "federate_private_a" {
  vpc_id = data.aws_vpc.federated_vpc.id
  id = "subnet-052bed3cbc24abe15"
}


resource "aws_redshift_subnet_group" "spreekauf_predictive" {
  name        = "spreekauf-predictive-subnet-group"
  description = "Subnet group for SpreeKauf predictive Redshift cluster"

  subnet_ids = [
    data.aws_subnet.federate_private_a.id,
    data.aws_subnet.federate_public_a.id
  ]
  tags = {
    Name        = "spreekauf-predictive-subnet-group"
    Environment = "Prod"
  }
}


resource "aws_security_group" "redshift_sg_predictive" {
  name        = "redshift-sg-predictive"
  description = "Security group for Redshift cluster"
  vpc_id      = data.aws_vpc.federated_vpc.id
  tags = {
    Name        = "redshift-sg-predictive"
    Environment = "Prod"
  }
}

resource "aws_security_group_rule" "sg_ingress_https" {
  security_group_id = aws_security_group.redshift_sg_predictive.id
  type              = "ingress"
  description       = "Allow HTTPS traffic"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
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
  cluster_type                 = "multi-node"
  number_of_nodes              = 3
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

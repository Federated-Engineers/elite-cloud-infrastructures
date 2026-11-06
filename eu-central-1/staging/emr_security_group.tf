resource "aws_security_group" "emr_primary" {
  name                   = "elite-emr-staging-primary-sg"
  description            = "EMR primary node"
  vpc_id                 = data.aws_vpc.emr.id
  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name                                       = "elite-emr-staging-primary-sg"
    "for-use-with-amazon-emr-managed-policies" = "true"
  })
}

resource "aws_security_group" "emr_core_task" {
  name                   = "elite-emr-staging-core-task-sg"
  description            = "EMR core and task nodes"
  vpc_id                 = data.aws_vpc.emr.id
  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name                                       = "elite-emr-staging-core-task-sg"
    "for-use-with-amazon-emr-managed-policies" = "true"
  })
}

resource "aws_vpc_security_group_egress_rule" "emr_primary_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.emr_primary.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "emr_core_task_allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.emr_core_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

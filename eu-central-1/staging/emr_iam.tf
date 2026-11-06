# EMR SERVICE ROLE

resource "aws_iam_role" "emr_service" {
  name = "elite-emr-staging-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "049417293525"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:elasticmapreduce:eu-central-1:049417293525:*"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "elite-emr-staging-service-role" })
}

resource "aws_iam_role_policy_attachment" "emr_service_policy_v2" {
  role       = aws_iam_role.emr_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
}

resource "aws_iam_role_policy" "emr_service_pass_role" {
  name = "elite-emr-staging-pass-instance-role"
  role = aws_iam_role.emr_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PassRoleForEC2"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::049417293525:role/elite-emr-staging-*-instance-role"
        Condition = {
          StringLike = {
            "iam:PassedToService" = "ec2.amazonaws.com"
          }
        }
      }
    ]
  })
}

# APEX LOGISTICS INSTANCE ROLE

resource "aws_iam_role" "apex_logistics_emr_instance" {
  name = "elite-emr-staging-apex-logistics-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "elite-emr-staging-apex-logistics-instance-role" })
}

resource "aws_iam_role_policy" "apex_logistics_emr_instance_s3" {
  name = "elite-emr-staging-apex-logistics-s3-access"
  role = aws_iam_role.apex_logistics_emr_instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListLogsBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          module.apex_logistics_emr_logs_staging_bucket.arn
        ]
      },
      {
        Sid    = "ReadWriteLogs"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${module.apex_logistics_emr_logs_staging_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apex_logistics_emr_instance_ssm" {
  role       = aws_iam_role.apex_logistics_emr_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "apex_logistics_emr" {
  name = "elite-emr-staging-apex-logistics-instance-role"
  role = aws_iam_role.apex_logistics_emr_instance.name
}

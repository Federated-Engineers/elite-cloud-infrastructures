
resource "aws_iam_policy" "staging_bucket_rw" {
  name = "staging-bucket-read-write"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = aws_s3_bucket.example.arn
      },
      {
        Sid    = "ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.example.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user" "staging_user" {
  name = "staging-user"
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.staging_user.name
  policy_arn = aws_iam_policy.staging_bucket_rw.arn
}

resource "aws_iam_access_key" "staging_user_key" {
  user = aws_iam_user.staging_user.name
}

resource "aws_ssm_parameter" "staging_access_key" {
  name  = "/staging/system-user/access-key"
  type  = "SecureString"
  value = aws_iam_access_key.staging_user_key.id
}

resource "aws_ssm_parameter" "staging_secret_key" {
  name  = "/staging/system-user/secret-key"
  type  = "SecureString"
  value = aws_iam_access_key.staging_user_key.secret
}


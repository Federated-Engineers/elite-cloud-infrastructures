resource "aws_iam_openid_connect_provider" "github-actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  tags           = merge(local.common_tags, { Name = "elite-open-id" })
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github-actions.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = ["repo:Federated-Engineers/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "github-actions-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  tags               = merge(local.common_tags, { Name = "elite-open-id" })
}

data "aws_iam_policy_document" "ecr_push_policy" {
  statement {
    sid    = "GetAuthorizationToken"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = ["arn:aws:ecr:eu-central-1:049417293525:repository/elite-dbt"]
  }
}

resource "aws_iam_policy" "ecr_push" {
  name        = "github-actions-ecr-push-policy"
  description = "Allows GitHub Actions to push images to dbt-test ECR"
  policy      = data.aws_iam_policy_document.ecr_push_policy.json
  tags        = merge(local.common_tags, { Name = "elite-open-id" })
}

resource "aws_iam_role_policy_attachment" "ecr_push_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

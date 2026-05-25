resource "aws_ecr_repository" "elite_airflow" {
  name                 = "elite-airflow"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-airflow" })
}


data "aws_ecr_lifecycle_policy_document" "elite_airflow" {
  rule {
    priority    = 1
    description = "To delete ecr images so that only the last 3 recent images are kept"
    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_airflow" {
  repository = aws_ecr_repository.elite_airflow.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_airflow.json
}

resource "aws_ecr_repository" "elite_dbt" {
  name                 = "elite-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.common_tags, {
    Name = "elite-dbt"
  })
}

data "aws_ecr_lifecycle_policy_document" "elite_dbt" {

  rule {
    priority    = 1
    description = "Keep only latest 3 dbt images"

    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_dbt" {

  repository = aws_ecr_repository.elite_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_dbt.json
}

resource "aws_ecr_repository" "elite_lone_star" {
  name                 = "elite-lone-star"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-lone-star" })
}


data "aws_ecr_lifecycle_policy_document" "elite_lone_star" {
  rule {
    priority    = 1
    description = "To delete old ecr images but keet the 3 most recent images"
    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_lone_star" {
  repository = aws_ecr_repository.elite_lone_star.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_lone_star.json
}


resource "aws_ecr_repository" "elite_kings_county_ledger_dbt" {
  name                 = "elite-kings-county-ledger-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-kings-county-ledger-dbt" })
}


data "aws_ecr_lifecycle_policy_document" "elite_kings_county_ledger_dbt" {
  rule {
    priority    = 1
    description = "Keep only latest 3 dbt images"
    action {
      type = "expire"
    }

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 3
    }
  }
}

resource "aws_ecr_lifecycle_policy" "elite_kings_county_ledger_dbt" {
  repository = aws_ecr_repository.elite_kings_county_ledger_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_kings_county_ledger_dbt.json
}
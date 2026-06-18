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

resource "aws_ecr_repository" "elite_lone_star_dbt" {
  name                 = "elite-lone-star-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-lone-star-dbt" })
}


data "aws_ecr_lifecycle_policy_document" "elite_lone_star_dbt" {
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

resource "aws_ecr_lifecycle_policy" "elite_lone_star_dbt" {
  repository = aws_ecr_repository.elite_lone_star_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_lone_star_dbt.json
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

resource "aws_ecr_repository" "elite_cocosurf_gear_dbt" {
  name                 = "elite-cocosurf-gear-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.common_tags, { Name = "elite-cocosurf-gear-dbt" })
}

data "aws_ecr_lifecycle_policy_document" "elite_cocosurf_gear_dbt" {
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

resource "aws_ecr_lifecycle_policy" "elite_cocosurf_gear_dbt" {
  repository = aws_ecr_repository.elite_cocosurf_gear_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_cocosurf_gear_dbt.json
}

resource "aws_ecr_repository" "elite_lonestar_dbt" {
  name                 = "elite-lonestar-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.common_tags, {
    Name = "elite_lonestar-dbt"
  })
}

data "aws_ecr_lifecycle_policy_document" "elite_lonestar_dbt" {

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

resource "aws_ecr_lifecycle_policy" "elite_lonestar_dbt" {

  repository = aws_ecr_repository.elite_lonestar_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_lonestar_dbt.json
}


resource "aws_ecr_repository" "elite_angelcity_dbt" {
  name                 = "elite-angelcity-dbt"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(local.common_tags, {
    Name = "elite_angelcity-dbt"
  })
}

data "aws_ecr_lifecycle_policy_document" "elite_angelcity_dbt" {

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

resource "aws_ecr_lifecycle_policy" "elite_angelcity_dbt" {

  repository = aws_ecr_repository.elite_angelcity_dbt.name

  policy = data.aws_ecr_lifecycle_policy_document.elite_angelcity_dbt.json
}



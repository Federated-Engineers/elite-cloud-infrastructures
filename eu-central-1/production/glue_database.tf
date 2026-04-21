resource "aws_glue_catalog_database" "elite_prod" {
  name = "scheldt-production-database"

  tags = merge(local.common_tags, {
    Owner   = "Scheldt-River-Logistics",
    Service = "elite-airflow"
  })
}

resource "aws_glue_catalog_database" "scardinavas_db" {
  name = "elite-production-scardinavas"

  tags = merge(local.common_tags, {
    Owner   = "scardinavas-monaco",
    Service = "elite-airflow"
  })
}
resource "aws_glue_catalog_database" "horlogerie_de_geneve_db" {
  name = "horlogerie-de-geneve"

  tags = merge(local.common_tags, {
    Owner   = "horlogerie-de-geneve",
    Service = "elite-airflow"
  })
}

resource "aws_glue_catalog_database" "liffey_luxury_db" {
  name = "elite-liffey-luxury"

  tags = merge(local.common_tags, {
    Owner   = "liffey-luxury",
    Service = "elite-airflow"
  })
}

resource "aws_glue_catalog_database" "mare_viva_db" {
  name = "elite-mare-viva"

  tags = merge(local.common_tags, {
    Owner   = "mare-viva",
    Service = "elite-airflow"
  })
}

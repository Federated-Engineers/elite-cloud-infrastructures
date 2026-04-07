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
  name = "horlogerie_de_geneve"

  tags = merge(local.common_tags, {
    Owner   = "horlogerie_de_geneve",
    Service = "elite-airflow"
  })
}

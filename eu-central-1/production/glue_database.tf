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
resource "aws_glue_catalog_database" "Horlogerie_de_Genève_db" {
  name        = "Horlogerie_de_Genève"

  tags = merge(local.common_tags, {
    Owner   = "Horlogerie_de_Genève",
    Service = "elite-airflow"
  })
}

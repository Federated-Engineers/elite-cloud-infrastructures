locals {
  common_tags = {
    environment = var.environment
    team        = var.team
    project     = var.project
    terraform   = true
  }
}

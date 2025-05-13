locals {
  resource_group_name    = "${var.project_name}-${var.environment}-rg"
  sql_server_name        = "${var.project_name}-${var.environment}-sql"
  vnet_name              = "${var.project_name}-${var.environment}-vnet"
  storage_account_name   = lower(replace("${var.project_name}${var.environment}stor", "-", ""))
  web_app_name           = "${var.project_name}-${var.environment}-webapp"
  app_service_plan_name  = "${var.project_name}-${var.environment}-plan"

  common_tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

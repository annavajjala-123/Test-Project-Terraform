terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

}

resource "azurerm_resource_group" "testingrg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "sql_server" {
  source              = "./modules/sql_server"
  name                = local.sql_server_name
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
  admin_login         = var.sqllogin
  admin_password      = var.sqlpassword
  tags                = local.common_tags
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = local.storage_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
  tags                = local.common_tags
}

module "web_app" {
  source                = "./modules/web_app"
  name                  = local.web_app_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.testingrg.name
  app_service_plan_name = local.app_service_plan_name
  tags                  = local.common_tags
}

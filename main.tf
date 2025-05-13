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

resource "azurerm_virtual_network" "testvnet" {
  name                = local.vnet_name
  address_space       = ["10.10.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
}

resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.testingrg.name
  virtual_network_name = azurerm_virtual_network.testvnet.name
  address_prefixes     = ["10.10.1.0/24"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                                           = "private-endpoint-subnet"
  resource_group_name                            = azurerm_resource_group.testingrg.name
  virtual_network_name                           = azurerm_virtual_network.testvnet.name
  address_prefixes                               = ["10.10.2.0/24"]
  enforce_private_link_service_network_policies  = true
}

module "sql_server" {
  source              = "./modules/sql_server"
  name                = local.sql_server_name
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
  admin_login         = var.sqllogin
  admin_password      = var.sqlpassword
  vnet_id             = azurerm_virtual_network.testvnet.id
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id
  sql_sku_name         = var.sql_sku_name
  tags                = local.common_tags
 
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = local.storage_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
  tags                = local.common_tags
  vnet_id             = azurerm_virtual_network.testvnet.id
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id
  
}


module "web_app" {
  source              = "./modules/web_app"
  location            = var.location
  resource_group_name = azurerm_resource_group.testingrg.name
  name                = var.name
  web_subnet_id             = azurerm_subnet.web_subnet.id
  private_endpoint_subnet_id = azurerm_subnet.private_endpoint_subnet.id
  vnet_id                   = azurerm_virtual_network.testvnet.id
  tags                      = local.common_tags
}

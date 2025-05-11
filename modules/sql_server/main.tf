resource "azurerm_mssql_server" "testingsqlserver" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
  version                      = "12.0"
  tags                         = var.tags
}

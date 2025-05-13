resource "azurerm_sql_server" "testsql" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
  tags                         = var.tags

  identity {
    type = "SystemAssigned"
  }

}  

resource "azurerm_sql_database" "testdb" {
  name                = "test-sqldb"
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.testsql.name
}


resource "azurerm_private_dns_zone" "testsql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "testsql" {
  name                  = "test-sql-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.testsql.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_endpoint" "testsql" {
  name                = "test-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "test-sql-psc"
    private_connection_resource_id = azurerm_sql_server.testsql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.testsql.id]
  }
}

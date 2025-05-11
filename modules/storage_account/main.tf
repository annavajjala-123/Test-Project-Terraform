resource "azurerm_storage_account" "testingstorage" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

 blob_properties {
    delete_retention_policy {
      days = 7
    }
}
  tags = var.tags
}

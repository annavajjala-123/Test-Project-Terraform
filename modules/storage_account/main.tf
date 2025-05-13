resource "azurerm_storage_account" "teststorage" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "appdata"
  storage_account_name  = azurerm_storage_account.teststorage.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "policy" {
  storage_account_id = azurerm_storage_account.teststorage.id

  rule {
    name    = "delete-old-logs"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
      prefix_match = ["logs/"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 90
      }

      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
}

resource "azurerm_private_endpoint" "pe" {
  name                = "teststorageprivate"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "test-pe-conn"
    private_connection_resource_id = azurerm_storage_account.teststorage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "storagetest-dnslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_a_record" "dns_record" {
  name                = azurerm_storage_account.teststorage.name
  zone_name           = azurerm_private_dns_zone.dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address]
}


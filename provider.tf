#Provider block definition with subscription deatils
provider "azurerm" {
 features {}
 subscription_id=war.azure_subscription_id
 client_id=war.azure_client_id
 client_secret=war.azure_client_secret
 tenant_id=war.azure_tenant_id
 }
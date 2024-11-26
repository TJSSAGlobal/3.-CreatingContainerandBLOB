# We first specify the terraform provider. 
# Terraform will use the provider to ensure that we can work with Microsoft Azure

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.33.0"
    }
  }
}

# Here we need to mention the Azure AD Application Object credentials to allow us to work with 
# our Azure account

provider "azurerm" {

  subscription_id = "7d398972-02be-4ed0-ac21-2df823eb6bf9"
  client_id       = "13b29fcc-90a3-4805-922e-415fccdb5beb"
  client_secret   = "P3E8Q~-.OJBua3dVpLGWkbtSp6SyQbnYhvzQ3a1L"
  tenant_id       = "85d3d2d0-e41a-4759-ac99-6bc18c0b5f4b"

  features {}
}

# The resource block defines the type of resource we want to work with
# The name and location are arguements for the resource block

 resource "azurerm_resource_group" "myresourcegroup"{
  name="myresourcegroup7967" 
  location="UK South"
 }

resource "azurerm_storage_account" "storage_account" {
  name                     = "tjsmysa7967"
  resource_group_name      = "myresourcegroup7967"
  location                 = "UK South"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.myresourcegroup ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "tjsmysa7967"
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.storage_account ]
}

# This is used to upload a local file onto the container
resource "azurerm_storage_blob" "success" {
  name                   = "success.txt"
  storage_account_name   = "tjsmysa7967"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "success.txt"
  depends_on = [ azurerm_storage_container.data ]
}
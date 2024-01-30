#Create Resource group
resource "azurerm_resource_group" "rg" {
 name = "webapp-resource-group"
 location = "East US"
 }
 
 #Virtual Network(VPC)
 resource "azurerm_virtual_network" "vnet" {
  name = "webapp-vnet"
  address_space =["10.0.0.0/16"]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  }
 
#create subnet
resource "azurerm_subnet" "subnet" {
 name = "webapps-subnet"
 resource_group_name = azurerm_resource_group.rg.name
 virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/24"]
  }
  
# Private IP[network interface]
resource "azurerm_network_interface" "nic" {
 name = "webapp-nic"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 
 ip_configuration {
  name = "webapp-ip"
  subnet_id = azurerm_subnet.subnet.id
  private_ip_address_allocation = "Dynamic"
  public_ip_address_id = azurerm_public_ip.public_ip.id
  }
  }
  
# Public IP define
resource "azurerm_public_ip" "public_ip" {
 name = "webapp_pub_ip"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 allocation_method = "Static"
 }

#Virtual machine

resource "azurerm_linux_virtual_machine" "vm" {
 name = "webapp-vm"
 location =  azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 size = "Standard_B1s"
 admin_username = "adminuser"
 network_interface_ids = [
 azurerm_network_interface.nic.id,]
 
 admin_ssh_key {
	username = "adminuser"
	public_key = var.ssh_public_key
 }
 
 os_disk {
	caching = "ReadWrite"
	storage_account_type = "Standard_LRS"
	}

 source_image_reference {
 publisher = "Canonical"
 offer = "UbuntuServer"
 sku = "18.04_LTS"
 version = "latest"
 }
 }

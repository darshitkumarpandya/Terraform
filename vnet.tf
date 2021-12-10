resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-t"
  location            = azurerm_resource_group.TerraformRG.location
  resource_group_name = azurerm_resource_group.TerraformRG.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "tsubnet" {
  name                 = "tsubnet"
  resource_group_name  = azurerm_resource_group.TerraformRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix     = "10.0.2.0/24"
}

resource "azurerm_public_ip" "tpip" {
  name                = "tpip"
  resource_group_name = azurerm_resource_group.TerraformRG.name
  location            = azurerm_resource_group.TerraformRG.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "tnetworkinterface" {
  name                = "tnetworkinterface"
  location            = azurerm_resource_group.TerraformRG.location
  resource_group_name = azurerm_resource_group.TerraformRG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tpip.id
  }
}
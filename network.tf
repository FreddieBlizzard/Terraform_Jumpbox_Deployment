resource "azurerm_virtual_network" "vnet1" {
  name                = var.company_vnet_name
  address_space       = var.company_vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name

  tags = merge(var.tags, {
    utility = "network operation"
  })
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = "subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = each.value.address_prefixes
}
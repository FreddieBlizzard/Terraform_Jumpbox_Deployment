resource "azurerm_network_security_group" "management_nsg" {
  name                = "nsg-management"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags                = var.tags

  security_rule {
    name                       = "Allow_RDP_Trusted"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.allowed_rdp_source_ip
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Deny_Any_Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "management_assoc" {
  subnet_id                 = azurerm_subnet.subnets["management"].id
  network_security_group_id = azurerm_network_security_group.management_nsg.id
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "nsg-private"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-RDP-From-Management-Subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_assoc" {
  subnet_id                 = azurerm_subnet.subnets["private"].id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}
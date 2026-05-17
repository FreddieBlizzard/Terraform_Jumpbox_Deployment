# Spinning up a File Server VM
resource "azurerm_windows_virtual_machine" "vm_fs" {
  name                = var.vm_file_server_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  size                = var.vm_file_server_size

  # Setting up creds for RDP access
  admin_username = var.admin_username
  admin_password = var.admin_password

  # Assigning the NIC to the VM using its Azure resource ID
  network_interface_ids = [
    azurerm_network_interface.vm_fs_nic.id
  ]

  # Hard drvive assignment, local redundancy only needed
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # OS Setup
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

}

# Setting up NIC for File Server
resource "azurerm_network_interface" "vm_fs_nic" {
  name                = "${var.vm_file_server_name}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["private"].id
    private_ip_address_allocation = "Dynamic"
  }
}

# Setting up Public IP for Jumpbox Server
resource "azurerm_public_ip" "jumpbox_pip" {
  name                = "${var.jumpbox_vm_name}-pip"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = merge(var.tags, {
    role = "jumpbox"
  })
}

# Setting up NIC for Jumpbox Public IP
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.jumpbox_vm_name}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = merge(var.tags, {
    role = "jumpbox"
  })

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets["management"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_pip.id
  }
}

# Spinning up Jumpbox VM
resource "azurerm_windows_virtual_machine" "jumpbox_vm" {
  name                = var.jumpbox_vm_name
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  size                = var.jumpbox_vm_size

  # Jumpbox creds setup through variables
  admin_username = var.jumpbox_admin_username
  admin_password = var.jumpbox_admin_password

  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  tags = merge(var.tags, {
    role = "jumpbox"
  })
}
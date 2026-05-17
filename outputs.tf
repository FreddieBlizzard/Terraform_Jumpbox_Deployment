output "resource_group_name" {
  description = "Name of the deployed resource group"
  value       = azurerm_resource_group.rg1.name
}

output "resource_group_id" {
  description = "ID of the deployed resource group"
  value = azurerm_resource_group.rg1.id
}

output "jumpbox_public_ip" {
  description = "Pubilc IP of jumpbox reachable via RDP, only for hosts with approved Public IPs"
  value = azurerm_public_ip.jumpbox_pip.ip_address
}

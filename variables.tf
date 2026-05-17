variable "tags" {
  type = map(string)
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "subscription_id" {
  description = "The Subscription ID on Azure"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "company_vnet_name" {
  description = "Name of the company virtual network"
  type        = string
}

variable "company_vnet_address_space" {
  description = "IP Addresses for the company virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "All subnets"
  type = map(object({
    address_prefixes = list(string)
  }))
}

variable "vm_file_server_name" {
  type = string
}

variable "vm_file_server_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
  # Note - the password will need to be entered at runtime
}

variable "jumpbox_vm_name" {
  type = string
}

variable "jumpbox_vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "jumpbox_admin_username" {
  type = string
}

variable "jumpbox_admin_password" {
  type      = string
  sensitive = true
  # Note - the password will need to be entered at runtime
}

variable "allowed_rdp_source_ip" {
  description = "Public IP for RDP access"
  type        = string
}

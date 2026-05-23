tags = {
  environment = "dev"
  project     = "project_jumpjump"
  owner       = "freddie"
}

resource_group_name = "Dev_Resource_Group"
location            = "East US"

company_vnet_name          = "Company_Virtual_Network"
company_vnet_address_space = ["10.0.0.0/16"]

vm_file_server_name    = "vm-file-01"
vm_file_server_size    = "Standard_D2s_v3"
admin_username         = "adminuser"

jumpbox_vm_name        = "vm-jump-01"
jumpbox_vm_size        = "Standard_D2s_v3"
jumpbox_admin_username = "azureuser"

subnets = {
  management = {
    address_prefixes = ["10.0.1.0/24"]
  }
  public = {
    address_prefixes = ["10.0.2.0/24"]
  }
  private = {
    address_prefixes = ["10.0.3.0/24"]
  }
}

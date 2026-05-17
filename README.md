### *Jumpbox Azure Design Lab*
___
This project demonstrates the deployment of a segmented Azure network using Terraform. It uses a jumpbox server as an intermediary to provide controlled access to a private internal file server. The project is designed to evolve over time as I continue learning IaC and Azure infrastructure design.

___
### Architecture:
  
**Local Machine**

*↓ RDP (restricted to single approved IP)*  

**Jumpbox VM** (Management Subnet, Public IP) 

*↓ RDP (internal network only)*  

**File Server VM** (Private Subnet, no public access)

<br/>

___
### Key Features:

* Infrastructure as Code using Terraform.
* Virtual Network segmentation:
    * Management subnet
    * Public subnet
    * Private subnet
* Network Security Groups (NSGs) enforcing access control.
* Jumpbox architecture for secure remote access.
* Private VM isolation (no direct internet exposure).
* Parameter-driven deployment using variables, tfvars, and runtime credentials.

<br/>

___
### Security Design:

This project emphasizes a layered security approach:

* RDP access to the public-facing jumpbox is restricted to a single public IP, since it is the only outside-accessible resource.
* The private File Server VM can only be accessed from outside the virtual network via this jumpbox.
* NSG rules follow the principle of least privilege by allowing RDP access only from approved sources and restricting private server access to traffic from the management subnet.

<br/>

___
### Terraform File Structure:

`providers.tf` → provider configuration   
`core.tf` → resource group   
`network.tf` → VNet + subnets   
`security.tf` → NSGs + rules   
`compute.tf` → VMs, NICs, public IP   
`variables.tf` → input variables  
`outputs.tf` → output variables

<br/>

___

### Prerequisites

* Terraform CLI
* Code editor (e.g. VS Code)
* Azure Subscription
* Azure CLI
* Git

<br/>

___
### Getting Started

1) *Clone Repository.*
```powershell
git clone <repo_URL>
cd terraform_jump_deployment
```


2) *Create variables file (ensure your public IP is updated here).*
```powershell
copy terraform.tfvars.example terraform.tfvars 
```


3) *Initialize Terraform directory for provider/module installation.*
```powershell
terraform init
```

4) *Review Terraform Deployment for changes to environment.*
```powershell
terraform plan
```


5) *Deploy infrastructure to go live.*
```powershell
terraform apply
```

6) *Retrieve the connection info for next step (also including resource group info).*
```powershell
terraform output
```

7) *Connect to jumpbox public IP via local Remote Desktop.*

<br/>

8) *Connect to internal File Server via remote desktop on jumpbox.*

<br/>

9) *Destroy environment after done with use.*

    **Note: In production environments, resources may be deallocated instead of destroyed when they need to be preserved while reducing compute costs.**

<br/>

___

### Example Variables 

Create a `terraform.tfvars` file using the format below. Replace the placeholder values with your own Azure subscription, public IP, and new variable names if preferred.

```hcl
tags = {
  environment = "dev"
  project     = "azure-jumpbox"
}

resource_group_name = "rg-terraform-jumpbox-lab"
subscription_id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
location            = "East US"

company_vnet_name          = "vnet-jumpbox-lab"
company_vnet_address_space = ["10.0.0.0/16"]

vm_file_server_name = "vm-file-01"
vm_file_server_size = "Standard_D2s_v3"
admin_username      = "fileadmin"

jumpbox_vm_name        = "vm-jump-01"
jumpbox_vm_size        = "Standard_D2s_v3"
jumpbox_admin_username = "jbadmin"

allowed_rdp_source_ip = "X.X.X.X/32"

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
```
> Password variables are intentionally not included in this example. Sensitive values should be provided at runtime or through environment variables.

### Notes

- Terraform state files are excluded via `.gitignore`
- Sensitive values are not stored in version control

<br/>

___
### Author
Freddie Plaza

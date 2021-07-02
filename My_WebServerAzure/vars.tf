variable "env_id" {
  description = "The ID of enviroment"
  type        = string
  default     = "qa1"
}

variable "location" {
  description = "The specific region in MS Azure"
  type        = string
  default     = "westus2"
}

variable "vnet_cidr" {
  description = "The vnet CIDR"
  type        = string
  default     = "10.110.0.0/16"
}

variable "azureuser_password" {
    default = "aBc_12345678"
}

variable "vms" {
  description = "The map of vms properties"
  type        = map(any)
  default = {
    vm1 = {
      size                 = "Standard_F2"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "Canonical"
      offer                = "UbuntuServer"
      sku                  = "16.04-LTS"
      version              = "latest"
      zone                 = "1"
    }
    vm2 = {
      size                 = "Standard_F2"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "Canonical"
      offer                = "UbuntuServer"
      sku                  = "16.04-LTS"
      version              = "latest"
      zone                 = "2"
    }
  }
}


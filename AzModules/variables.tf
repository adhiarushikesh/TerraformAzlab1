variable "location" { 
    default = "southeastasia"
}
# declare variables and defaults
variable "environment" {
    default = "dev"
}
variable "vm_size" {
    default = {
        "dev"   = "Standard_B2s"
        "prod"  = "Standard_D2s_v3"
    }
}
variable "admin_username" {
    default = "tadmin"
}
variable "admin_password" {
    default = "PL@net09"
}
variable "tags" {
    default = {
        Environment = "Terraform GS"
        Dept = "Engineering"
  }
}
variable "sku" {
    default = {
        southeastasia = "16.04-LTS"
        westus = "16.04-LTS"
        eastus = "18.04-LTS"
    }
}
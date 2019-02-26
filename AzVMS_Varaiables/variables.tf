variable "location" { 
    default = "southeastasia"
}

variable "admin_username" {
    default = "tadmin"
}
variable "admin_password" {
    default = "PL@net09"
}
variable "resource_prefix" {
    type = "string"
    default = "RG"
}
variable "tags" {
    type = "map"
    default = {
        Environment = "Terraform GS"
        Dept = "Engineering"
  }
}
variable "sku" {
    default = {
        westus = "16.04-LTS"
        eastus = "18.04-LTS"
    }
}
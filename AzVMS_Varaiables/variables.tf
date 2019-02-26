variable "location" { 
    default = "southeastasia"
}

variable "admin_username" {
    default = "tadmin"
}
variable "admin_password" {
    default = "PL@net09"
}
variable "prefix" {
    type = "string"
    default = "MY"
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
        southeastasia = "16.04-LTS"
        westus = "16.04-LTS"
        eastus = "18.04-LTS"
    }
}
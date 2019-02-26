/*
* Demonstrate use of provisioner 'remote-exec' to execute a command
* on a new VM instance.
*/
/*
* NOTE: It is very poor practice to hardcode sensitive information
* such as user name, password, etc. Hardcoded values are used here
* only to simplify the tutorial.
*/


# Configure the Microsoft Azure Provider.
provider "azurerm" {
    version = "=1.20.0"
}
# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.resource_prefix}09"
    location = "${var.location}"
    tags     = "${var.tags}"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${azurerm_resource_group.rg.name}_VM_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    tags                = "${var.tags}"
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "${azurerm_resource_group.rg.name}_VM_Subnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.0.1.0/24"
    tags                = "${var.tags}"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
    name                         = "${azurerm_resource_group.rg.name}_VM_PublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation = "dynamic"
    tags                = "${var.tags}"
    }

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "${azurerm_resource_group.rg.name}_VM_NSG"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    tags                = "${var.tags}"
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "${azurerm_resource_group.rg.name}_VM_NIC"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    tags                      = "${var.tags}"
    ip_configuration {
        name                          = "${azurerm_resource_group.rg.name}_VM_NICConfg"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
    }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "${azurerm_resource_group.rg.name}VM1"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    tags                  = "${var.tags}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "Standard_B1ms"
    #vm_size              = "Standard_B2s"
    storage_os_disk {
        name              = "${azurerm_resource_group.rg.name}_OSDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${azurerm_resource_group.rg.name}VM3"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }
 provisioner "file" {
    connection {
    type = "ssh"
    user = "${var.admin_username}"
    password = "${var.admin_password}"
    }
    source = "C:/opscode/Terraform/AZVM_provisnior/newfile.txt"
    destination = "/tmp/newfile.txt"
 }
 provisioner "remote-exec" {
    when = "destroy"
    connection {
    type = "ssh"
    user     = "${var.admin_username}"
    password = "${var.admin_password}"
    }
    inline = [
    "ls -a",
    "cat newfile.txt"
    ]
  }
  output "ip" {
    value = "${azurerm_public_ip.publicip.ip_address}"
  }

  output "os_sku" {
    value = "${lookup(var.sku, var.location)}"
  }
  
 }
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Rendom password from ubuntu administrator
  resource "random_password" "my_password" {
  length  = 10
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a resource group if it doesn’t exist.
resource "azurerm_resource_group" "BootcampTerraformRG" {
    name                    = "${var.resource_prefix}-RG"
    location                = "${var.location}"
    tags                    = "${var.tags}"
}

# Create virtual network with public and private subnets.
resource "azurerm_virtual_network" "BootcampTerrafotmVnet" {
    name                    = "${var.resource_prefix}-Vnet"
    address_space           = ["10.0.0.0/16"]
    location                = "${var.location}"
    resource_group_name     = "${azurerm_resource_group.BootcampTerraformRG.name}"

    tags = "${var.tags}"
}

# Create public subnet 1.
resource "azurerm_subnet" "BootcampTerraformPublic-sbn" {
  name                      = "${var.resource_prefix}-Pblc-nsg1"
  resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.BootcampTerrafotmVnet.name}"
  address_prefixes          = ["10.0.1.0/24"]
}
# Create public subnet 2.
resource "azurerm_subnet" "BootcampTerraformPublic-sbn2" {
  name                      = "${var.resource_prefix}-Pblc-nsg2"
  resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.BootcampTerrafotmVnet.name}"
  address_prefixes          = ["10.0.2.0/24"]
}
# Create public subnet 3.
resource "azurerm_subnet" "BootcampTerraformPublic-sbn3" {
  name                      = "${var.resource_prefix}-Pblc-nsg3"
  resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.BootcampTerrafotmVnet.name}"
  address_prefixes          = ["10.0.3.0/24"]
}

# Availability set
resource "azurerm_availability_set" "BootcampTerraformSet" {
  name                         = "${var.resource_prefix}-set"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.BootcampTerraformRG.name}"
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3  
}

# Create network security group and SSH rule for public subnet.
resource "azurerm_network_security_group" "BootcampTerraformPublic_nsg" {
  name                         = "${var.resource_prefix}-Pblc-nsg"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.BootcampTerraformRG.name}"

  # Allow SSH traffic in from Internet to public subnet.
  security_rule {
    name                       = "allow-ssh-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-8080-all"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${var.tags}"
}

# Associate network security group with public subnet1.
resource "azurerm_subnet_network_security_group_association" "BootcampTerraformPublic_subnet_assoc" {
  subnet_id                    = "${azurerm_subnet.BootcampTerraformPublic-sbn.id}"
  network_security_group_id    = "${azurerm_network_security_group.BootcampTerraformPublic_nsg.id}"
}
# Associate network security group with public subnet2.
resource "azurerm_subnet_network_security_group_association" "BootcampTerraformPublic_subnet_assoc2" {
  subnet_id                    = "${azurerm_subnet.BootcampTerraformPublic-sbn2.id}"
  network_security_group_id    = "${azurerm_network_security_group.BootcampTerraformPublic_nsg.id}"
}
# Associate network security group with public subnet3.
resource "azurerm_subnet_network_security_group_association" "BootcampTerraformPublic_subnet_assoc3" {
  subnet_id                    = "${azurerm_subnet.BootcampTerraformPublic-sbn3.id}"
  network_security_group_id    = "${azurerm_network_security_group.BootcampTerraformPublic_nsg.id}"
}

# Create a public IP address for public 1.
resource "azurerm_public_ip" "BootcampTerraformPublic_ip" {
    name                       = "${var.resource_prefix}-Ip"
    location                   = "${var.location}"
    resource_group_name        = "${azurerm_resource_group.BootcampTerraformRG.name}"
    sku                        = "Standard"
    allocation_method          = "Static"

    tags = "${var.tags}"
}
# Create a public IP address for public 2.
resource "azurerm_public_ip" "BootcampTerraformPublic_ip2" {
    name                       = "${var.resource_prefix}-Ip2"
    location                   = "${var.location}"
    resource_group_name        = "${azurerm_resource_group.BootcampTerraformRG.name}"
    sku                        = "Standard"
    allocation_method          = "Static"

    tags = "${var.tags}"
}
# Create a public IP address for public 3.
resource "azurerm_public_ip" "BootcampTerraformPublic_ip3" {
    name                       = "${var.resource_prefix}-Ip3"
    location                   = "${var.location}"
    resource_group_name        = "${azurerm_resource_group.BootcampTerraformRG.name}"
    sku                        = "Standard"
    allocation_method          = "Static"

    tags = "${var.tags}"
}

# Create network interface for public subnet1.
resource "azurerm_network_interface" "BootcampTerraformPublic_nic" {
    name                      = "${var.resource_prefix}-Pblc-nic"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"

    ip_configuration {
        name                          = "${var.resource_prefix}-Pblc-nic-cfg"
        subnet_id                     = "${azurerm_subnet.BootcampTerraformPublic-sbn.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.BootcampTerraformPublic_ip.id}"
    }

    tags = "${var.tags}"
}
# Create network interface for public subnet2.
resource "azurerm_network_interface" "BootcampTerraformPublic_nic2" {
    name                      = "${var.resource_prefix}-Pblc-nic2"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"
    ip_configuration {
        name                          = "${var.resource_prefix}-Pblc-nic-cfg2"
        subnet_id                     = "${azurerm_subnet.BootcampTerraformPublic-sbn2.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.BootcampTerraformPublic_ip2.id}"
    }

    tags = "${var.tags}"
}
# Create network interface for public subnet3.
resource "azurerm_network_interface" "BootcampTerraformPublic_nic3" {
    name                              = "${var.resource_prefix}-Pblc-nic3"
    location                          = "${var.location}"
    resource_group_name               = "${azurerm_resource_group.BootcampTerraformRG.name}"
    ip_configuration {
        name                          = "${var.resource_prefix}-Pblc-nic-cfg3"
        subnet_id                     = "${azurerm_subnet.BootcampTerraformPublic-sbn3.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.BootcampTerraformPublic_ip3.id}"
    }

    tags = "${var.tags}"
}

# Create public host 01.  
resource "azurerm_virtual_machine" "BootcampTerraformPublic_vm" {
    name                  = "${var.resource_prefix}-Pblc-vm1"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.BootcampTerraformRG.name}"
    availability_set_id   = "${azurerm_availability_set.BootcampTerraformSet.id}"
    network_interface_ids = ["${azurerm_network_interface.BootcampTerraformPublic_nic.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "${var.resource_prefix}-Pblc-dsk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher         = "Canonical"
        offer             = "UbuntuServer"
        sku               = "18.04-LTS"
        version           = "latest"
    }

    os_profile {
        computer_name     = "${var.resource_prefix}-Pblc-vm1"
        admin_username    = "${var.username}"
        admin_password    = "${random_password.my_password.result}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags                  = "${var.tags}"
}
# Create public host 2.
resource "azurerm_virtual_machine" "BootcampTerraformPublic_vm2" {
    name                  = "${var.resource_prefix}-Pblc-vm2"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.BootcampTerraformRG.name}"
    availability_set_id   = "${azurerm_availability_set.BootcampTerraformSet.id}"
    network_interface_ids = ["${azurerm_network_interface.BootcampTerraformPublic_nic2.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "${var.resource_prefix}-Pblc-dsk2"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher         = "Canonical"
        offer             = "UbuntuServer"
        sku               = "18.04-LTS"
        version           = "latest"
    }

    os_profile {
        computer_name     = "${var.resource_prefix}-Pblc-vm2"
        admin_username    = "${var.username}"
        admin_password    = "${random_password.my_password.result}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags                  = "${var.tags}"
}
# Create public host 3.
resource "azurerm_virtual_machine" "BootcampTerraformPublic_vm3" {
    name                  = "${var.resource_prefix}-Pblc-vm3"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.BootcampTerraformRG.name}"
    availability_set_id   = "${azurerm_availability_set.BootcampTerraformSet.id}"
    network_interface_ids = ["${azurerm_network_interface.BootcampTerraformPublic_nic3.id}"]
    vm_size               = "Standard_B1s"

    storage_os_disk {
        name              = "${var.resource_prefix}-Pblc-dsk3"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher         = "Canonical"
        offer             = "UbuntuServer"
        sku               = "18.04-LTS"
        version           = "latest"
    }

    os_profile {
        computer_name     = "${var.resource_prefix}-Pblc-vm3"
        admin_username    = "${var.username}"
        admin_password    = "${random_password.my_password.result}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags                  = "${var.tags}"
}

# Create a public IP address for LB.
resource "azurerm_public_ip" "BootcampTerraformPublic_ipLB" {
    name                  = "${var.resource_prefix}-IpLB"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.BootcampTerraformRG.name}"
    sku                     = "Standard"
    allocation_method       = "Static"

    tags                  = "${var.tags}"
}
# LB from public subnet
resource "azurerm_lb" "BootcampTerraformLB" {
  name                    = "${var.resource_prefix}-LB"
  location                = "${var.location}"
  resource_group_name     = "${azurerm_resource_group.BootcampTerraformRG.name}"
  sku                     = "Standard"
  sku_tier                = "Regional"
  frontend_ip_configuration {
    name                  = "frontend-ip"
    public_ip_address_id  = "${azurerm_public_ip.BootcampTerraformPublic_ipLB.id}"
  }
}

# Backend pool from LB
resource "azurerm_lb_backend_address_pool" "BootcampTerraformPool" {
  loadbalancer_id         = "${azurerm_lb.BootcampTerraformLB.id}"
  name                    = "${var.resource_prefix}-Pool"
}

# Pool addresses from LB
resource "azurerm_lb_backend_address_pool_address" "BootcampTerraformPublic_vm1_address" {
  name                    = "${var.resource_prefix}-Public_vm1_address"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.BootcampTerraformPool.id}"
  virtual_network_id      = "${azurerm_virtual_network.BootcampTerrafotmVnet.id}"
  ip_address              = "${azurerm_network_interface.BootcampTerraformPublic_nic.private_ip_address}"
}
resource "azurerm_lb_backend_address_pool_address" "BootcampTerraformPublic_vm2_address" {
  name                    = "${var.resource_prefix}-Public_vm2_address"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.BootcampTerraformPool.id}"
  virtual_network_id      = "${azurerm_virtual_network.BootcampTerrafotmVnet.id}"
  ip_address              = "${azurerm_network_interface.BootcampTerraformPublic_nic2.private_ip_address}"
}
resource "azurerm_lb_backend_address_pool_address" "BootcampTerraformPublic_vm3_address" {
  name                    = "${var.resource_prefix}-Public_vm3_address"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.BootcampTerraformPool.id}"
  virtual_network_id      = "${azurerm_virtual_network.BootcampTerrafotmVnet.id}"
  ip_address              = "${azurerm_network_interface.BootcampTerraformPublic_nic3.private_ip_address}"
}


# LB rule 8080
resource "azurerm_lb_rule" "BootcampTerraformLB" {
  loadbalancer_id                = "${azurerm_lb.BootcampTerraformLB.id}"
  name                           = "${var.resource_prefix}-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [ "${azurerm_lb_backend_address_pool.BootcampTerraformPool.id}" ]
}

# Create private subnet DataBase.
resource "azurerm_subnet" "BootcampTerraformPrivate_subnet" {
  name                      = "${var.resource_prefix}-prvt-sn001"
  resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"
  virtual_network_name      = "${azurerm_virtual_network.BootcampTerrafotmVnet.name}"
  address_prefixes          = ["10.0.20.0/24"]
}

# Create network security group and SSH rule for private subnet.
resource "azurerm_network_security_group" "BootcampTerraformPrivate_nsg" {
  name                = "${var.resource_prefix}-prvt-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.BootcampTerraformRG.name}"

# Allow SSH traffic in from public subnet to private subnet.
  security_rule {
    name                       = "allow-ssh-public-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

# Allow PostgreSQL potr subnet only.connection 
    security_rule {
    name                       = "allow-5432-public-subnet"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

# Block all outbound traffic from private subnet to Internet.
  security_rule {
    name                       = "deny-internet-all"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${var.tags}"
}

# Associate network security group with private subnet.
resource "azurerm_subnet_network_security_group_association" "BootcampTerraformPrivate_subnet_assoc" {
  subnet_id                 = "${azurerm_subnet.BootcampTerraformPrivate_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.BootcampTerraformPrivate_nsg.id}"
}

# Create network interface for Private subnet.
resource "azurerm_network_interface" "BootcampTerraformPrivate_nic" {
    name                      = "${var.resource_prefix}-prvt-nic"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.BootcampTerraformRG.name}"

    ip_configuration {
        name                          = "${var.resource_prefix}-privt-nic-cfg"
        subnet_id                     = "${azurerm_subnet.BootcampTerraformPrivate_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags = "${var.tags}"
}


# Create DataBase host VM.
resource "azurerm_virtual_machine" "BootcampTerraformDatabaseVM" {
    name                  = "${var.resource_prefix}-prvt-vm1"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.BootcampTerraformRG.name}"
    network_interface_ids = ["${azurerm_network_interface.BootcampTerraformPrivate_nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.resource_prefix}-prvt-dsk001"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.resource_prefix}-prvt-vm001"
        admin_username = "${var.username}"
        admin_password = "${random_password.my_password.result}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags = "${var.tags}"
}


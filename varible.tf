# Define prefix for consistent resource naming.
variable "resource_prefix" {
    type        = string
    default     = "BootcampTerraform1"
    description = "Service prefix to use for naming of resources."
}

# Define Azure region for resource placement.
variable "location" {
    type        = string
    default     = "westus"
    description = "Azure region for deployment of resources."
}

variable "username" {
    type        = string
    default     = "alex"
    description = "User from ubuntu"
}


# Define the common tags for all resources.
variable "tags" {
    description = "A map of the tags to use for the resources"
    type = map

    default = {
        name    = "BootcampTerraform"
        owner   = "Alex Merkushyn"
        mail    = "amerkushin@gmail.com"
    }
}
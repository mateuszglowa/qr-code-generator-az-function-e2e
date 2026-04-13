variable "name" {
  description = "Name of the API Management instance."
  type        = string
}

variable "location" {
  description = "Azure region in which the API Management instance will be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group that contains the API Management instance."
  type        = string
}

variable "publisher_name" {
  description = "Name of the publisher / organisation."
  type        = string
}

variable "publisher_email" {
  description = "Email address of the publisher / organisation."
  type        = string
}

variable "sku_name" {
  description = "SKU name for the API Management instance (e.g. Developer_1, Standard_1, Premium_1)."
  type        = string
  default     = "Developer_1"
}

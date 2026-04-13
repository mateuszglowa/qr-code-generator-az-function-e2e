variable "name" {
  description = "The name of the storage account. Must be globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which to create the storage account."
  type        = string
}

variable "location" {
  description = "Azure location/region for the storage account."
  type        = string
}

variable "account_tier" {
  description = "The tier to use for this storage account. Valid values: `Standard`, `Premium`."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account. e.g. `LRS`, `GRS`, `ZRS`, `RAGRS`."
  type        = string
  default     = "LRS"
}

variable "kind" {
  description = "Specifies the Kind of the storage account. e.g. `StorageV2`, `BlobStorage`."
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "The access tier for the Blob storage. `Hot` or `Cool`."
  type        = string
  default     = "Hot"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
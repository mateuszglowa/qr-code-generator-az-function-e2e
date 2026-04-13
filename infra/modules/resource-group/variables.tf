variable "name" {
  description = "Resource Group Name"
  type        = string
}
variable "location" {
  description = "Resource Group Location"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
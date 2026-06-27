variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "security_contact_email" {
  type    = string
  default = "tvoj@email.com"
}

variable "subscription_id" {
  type    = string
  default = ""
}
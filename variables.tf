variable "project_name" {
  default = "testingproject"
}

variable "environment" {
  default = "dev"
}

variable "location" {
  default = "East US"
}

variable "sqllogin" {
default = "sqladmin"
}
variable "sqlpassword" {

  sensitive = true
default = "P@ssword1234!"
}

variable "client_id" {
default = "xxxxxxxxxxx"
}
variable "client_secret" {
default = "xxxxxxx"
}
variable "subscription_id" {
default = "xxxxxxxx"
}
variable "tenant_id" {
default = "xxxx"
}


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

variable "sql_sku_name" {
default = "testsqlskuuu"
}

variable "name"{
default = "test"
}
variable "client_id" {
default = "xxxxxx"
}
variable "client_secret" {
default = "xxxxxxxxxxxx"
}
variable "subscription_id" {
default = "xxxxxxx"
}
variable "tenant_id" {
default = "xxxxxxxxx"
}


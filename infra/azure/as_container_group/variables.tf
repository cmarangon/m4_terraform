variable "app_port" {
  type    = number
  default = 3000
}

variable "api_port" {
  type    = number
  default = 5001
}

variable "db_host" {
  type    = string
  default = "localhost"
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type = string
}

variable "db_database" {
  type    = string
  default = "todo_db"
}

variable "db_root_password" {
  type      = string
  sensitive = true
}

variable "database_url" {
  type      = string
  sensitive = true
}

variable "redis_password" {
  type      = string
  sensitive = true
}

variable "redis_host" {
  type    = string
  default = "localhost"
}

variable "redis_port" {
  type    = number
  default = 6379
}

variable "storage_key" {
  type = string
}

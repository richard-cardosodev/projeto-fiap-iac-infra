variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "fiap_projeto"
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type        = string
  default     = "ademar"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  default     = "pagodaodamassa123"
}

variable "private_subnet_1a" {}

variable "private_subnet_1b" {}
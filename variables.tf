variable "cluster_name" {
  default = "projeto-fiap"
}

variable "desired_size" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "region" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = 1.28
}

variable "lambda_auth_name" {
  default = "projeto-fiap-authorizer"
}

variable "lambda_jwt_name" {
  default = "projeto-fiap-jwt"
}

variable "db_cluster_name" {
  default = "DB_CLUSTER_NAME_HERE"
}
variable "db_name" {
  default = "DB_NAME_HERE"
}
variable "db_username" {
  default = "DB_USERNAME_HERE"
}
variable "db_password" {
  default = "DB_PASSWORD_HERE"
}
variable "db_port" {
  default = "DB_PORT_HERE"
}
variable "jwt_secret" {
  default = "JWT_SECRET_HERE"
}
variable "environment" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "public_subnet" {
  type = map(any)
}

variable "private_subnet" {
  type = map(any)
}

variable "private_subnet_RDS" {
  type = map(any)
}




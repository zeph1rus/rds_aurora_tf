variable "az1_subnet_cidrs" {
  type        = list(string)
  description = "The CIDR blocks for the subnets to be created"
  default = [
    "10.20.0.0/24",
    "10.20.10.0/24",
    "10.20.20.0/24"
  ]
}

variable "az2_subnet_cidrs" {
  type        = list(string)
  description = "The CIDR blocks for the subnets to be created"
  default = [
    "10.20.30.0/24",
    "10.20.40.0/24",
    "10.20.50.0/24"
  ]
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "tags" {
  type = map(string)
  default = {
    "environment" = "dev"
    "name"        = "rgtsdb"
  }
}
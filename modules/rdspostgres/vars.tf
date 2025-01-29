variable "cluster_identifier" {
  description = "The cluster identifier for the to be built cluster"
  type        = string
}

variable "database_name" {
  description = "The name of the database to be created"
  type        = string
}

variable "database_version" {
  description = "The version of the database to be created"
  type        = string
  default     = "16.6"
}

variable "master_username" {
  description = "The master username for the database"
  type        = string
}

variable "master_password" {
  description = "The master password for the database"
  type        = string
}

variable "tags" {
  description = "Resource tags to be applied to built resources"
  type        = map(string)
  default     = {}
}

variable "max_capacity" {
  description = "The maximum capacity for the serverless cluster in aurora capacity units"
  type        = number
  default     = 64
}

variable "min_capacity" {
  description = "The minimum capacity for the serverless cluster in aurora capacity units, as this is a dev database, this is set by default to 0 to allow auto-pause, which saves costs"
  type        = number
  default     = 0

}

variable "seconds_until_auto_pause" {
  description = "The amount of time in seconds that Aurora Serverless v2 waits before it pauses an idle DB cluster"
  type        = number
  default     = 3600
}

variable "subnet_group_name" {
  description = "The name of the subnet group to be created"
  type        = string
}

variable "subnet_group_subnet_ids" {
  description = "The subnet ids to be added to the subnet group"
  type        = list(string)
}

variable "tcp_port" {
  description = "The port for the DB to listen on"
  type        = number
  default     = 5432
}

variable "security_group_ids" {
  description = "The security group ids to be added to the cluster"
  type        = list(string)
}

variable "reader_username" {
  description = "The username for the read only user"
  type        = string
  default     = "reader"
}

variable "writer_username" {
  description = "The username for the write user"
  type        = string
  default     = "writer"
}
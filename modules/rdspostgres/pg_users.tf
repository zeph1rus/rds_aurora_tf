

resource "postgresql_role" "write_role" {
  name     = var.writer_username
  login    = true
  password = random_password.write_password.result

  depends_on = [time_sleep.wait_for_cluster_dns_to_propagate, aws_rds_cluster_instance.read, aws_rds_cluster_instance.write]
}

resource "postgresql_role" "read_role" {
  name     = var.reader_username
  login    = true
  password = random_password.read_password.result

  depends_on = [time_sleep.wait_for_cluster_dns_to_propagate, aws_rds_cluster_instance.read, aws_rds_cluster_instance.write]
}

resource "postgresql_grant" "remove_public" {
  object_type = "database"
  database    = var.database_name
  role        = "public"
  privileges  = []
  depends_on  = [postgresql_role.write_role]
}

resource "postgresql_grant" "write" {
  object_type = "database"
  database    = var.database_name
  role        = var.writer_username
  privileges  = ["ALL"]
  depends_on  = [postgresql_role.write_role]
}


resource "postgresql_grant" "read_grant" {
  object_type = "database"
  database    = var.database_name
  role        = var.reader_username
  privileges  = ["CONNECT"]
  depends_on  = [postgresql_role.read_role]
}

# give read to the default schema.  In general a lot more setup is needed for the db, 
# however this is a simple example, and also terraform is not usually the best tool
# for managing db schema.
resource "postgresql_grant" "read_select" {
  object_type = "schema"
  database    = var.database_name
  schema      = "public"
  role        = var.reader_username
  privileges  = ["USAGE"]
  depends_on  = [postgresql_role.read_role]
}

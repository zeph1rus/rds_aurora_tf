resource "aws_db_subnet_group" "subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_group_subnet_ids
  tags       = var.tags
}


resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier       = var.cluster_identifier
  deletion_protection      = false
  delete_automated_backups = true
  skip_final_snapshot      = true
  engine                   = "aurora-postgresql"
  engine_mode              = "provisioned"
  engine_version           = var.database_version
  database_name            = var.database_name
  master_username          = var.master_username
  master_password          = var.master_password
  storage_encrypted        = true
  tags                     = var.tags
  db_subnet_group_name     = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids   = var.security_group_ids



  serverlessv2_scaling_configuration {
    max_capacity             = var.max_capacity
    min_capacity             = var.min_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
  }
}

resource "aws_rds_cluster_instance" "write" {
  promotion_tier       = 0
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  publicly_accessible  = true
  tags                 = var.tags
}

resource "aws_rds_cluster_instance" "read" {
  promotion_tier       = 2
  cluster_identifier   = aws_rds_cluster.rds_cluster.id
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.rds_cluster.engine
  engine_version       = aws_rds_cluster.rds_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  publicly_accessible  = true
  tags                 = var.tags
}

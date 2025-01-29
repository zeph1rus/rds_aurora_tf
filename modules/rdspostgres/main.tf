terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql" # this provider replaces the old pg as hashicorp doesn't host community providers anymore
      version = "1.25.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}


provider "postgresql" {
  host     = aws_rds_cluster.rds_cluster.endpoint
  port     = var.tcp_port
  username = var.master_username
  password = var.master_password
  # RDS PG users aren't technically SU but they have the same rights as they're in the rds_superuser role 
  # (see: https://github.com/hashicorp/terraform-provider-postgresql/issues/77) , setting this to false to avoid
  # the error.
  superuser = false

}

resource "random_password" "read_password" {
  length  = 16
  special = true
  # as per the rds docs, password shouldn't contain /, ", @, or space, so we're excluding them by providing the special 
  # characters we want to include.  This is the same as the default list from the provider docs. 
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "write_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "time_sleep" "wait_for_cluster_dns_to_propagate" {
  # usually read completes first but we should depend on both for sanity.
  # this is required as if we hit the cluster straight away there is a slight delay for
  # the cluster write address to propogate to vpc dns, and it'll fail immediately, 
  # waiting for 90s should be enough to connect to the cluster
  depends_on      = [aws_rds_cluster_instance.write, aws_rds_cluster_instance.read]
  create_duration = "90s"
}


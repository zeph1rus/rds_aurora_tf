terraform {
  required_version = ">= 1.2.8"
  backend "s3" {
    bucket = "rgtstfstates"
    key    = "rds_dev.tfstate"
    region = "us-east-1"
  }

  required_providers {
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


provider "aws" {
  region = "us-east-1"
}

resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rdspostgres" {
  source                  = "../../modules/rdspostgres"
  cluster_identifier      = "rgtsauroracluster"
  database_name           = "rgtsauroradb"
  database_version        = "16.6"
  master_username         = "rgtstaurora_admin"
  master_password         = "random_password.master_password.result"
  tags                    = var.tags
  subnet_group_name       = "rgtsdbsubnetgroup"
  subnet_group_subnet_ids = concat(aws_subnet.rgtsdbsubnet_az1[*].id, aws_subnet.rgtsdbsubnet_az2[*].id)
  security_group_ids      = [aws_security_group.db_security_group.id]


}
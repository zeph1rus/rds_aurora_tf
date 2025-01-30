# RDS Postgres Module

## Summary

The `rdspostgres` module is designed to manage and configure Serverless Amazon RDS instances for PostgreSQL. It is designed to create a small, non global dev database with public access. It provides a set of inputs to customize the RDS instance and outputs to retrieve information about the created resources.

To use this module you must provide a VPC with subnets in two availability zones, with the following options enabled. It must also allow incoming connections to the DB from the networks you wish to use.

An example is provided in `src/dev`

```hcl
  enable_dns_support   = true
  enable_dns_hostnames = true
```

## Inputs

| Name                       | Description                                                             | Type        | Default  | Required |
| -------------------------- | ----------------------------------------------------------------------- | ----------- | -------- | -------- |
| `cluster_identifier`       | Name/ID of the cluster                                                  | string      | n/a      | yes      |
| `database_name`            | The name of the created database                                        | string      | n/a      | yes      |
| `master_username`          | The master username for the database                                    | string      | n/a      | yes      |
| `master_password`          | The master password for the database                                    | string      | n/a      | yes      |
| `vpc_security_group_ids`   | A list of VPC security group IDs to associate with the cluster          | list        | n/a      | yes      |
| `subnet_group_subnet_ids`  | A list of subnet IDs for the RDS instances                              | list        | n/a      | yes      |
| `subnet_group_name`        | The name of the subnet group will be created                            | string      | n/a      | yes      |
| `database_version`         | The version of the PostgreSQL engine                                    | string      | `16.6`   | no       |
| `max_capacity`             | The max capacity of the instances in Aurora Capacity Units              | number      | `64`     | no       |
| `min_capacity`             | The minimum capacity of the database, set to 0 to enable auto pause     | number      | `0`      | no       |
| `seconds_until_auto_pause` | The number of seconds the DB is idle before it auto pauses              | number      | `3600`   | no       |
| `tcp_port`                 | The TCP Port the DB Cluster will listen on                              | number      | `5432`   | no       |
| `reader_username`          | The username of the user which will be created with readonly privileges | string      | `reader` | no       |
| `writer_username`          | The username of the user which will be created with write privileges    | string      | `writer` | no       |
| `tags`                     | A Map containing the tags for the cluster and subresources              | map[string] | `{}`     | no       |

## Outputs

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| `write_endpoint`    | DNS Name for the cluster write endpoint |
| `read_endpoint`     | DNS Name for the cluster read endpoint  |
| `cluster_arn`       | The ARN of the created RDS cluster      |
| `cluster_id`        | ID for the RDS cluster                  |
| `cluster_port`      | The TCP Port the cluster listens on     |
| `cluster_instances` | A list containing the cluster instances |
| `write_username`    | The write username                      |
| `write_password`    | The password for the writer user        |
| `read_username`     | The read username                       |
| `read_password`     | The reader password                     |

output "write_endpoint" {
  description = "Write endpoint for the cluster"
  value       = aws_rds_cluster.rds_cluster.endpoint
}

output "read_endpoint" {
  description = "Read endpoint for the cluster"
  value       = aws_rds_cluster.rds_cluster.reader_endpoint
}

output "cluster_arn" {
  description = "ARN of the cluster"
  value       = aws_rds_cluster.rds_cluster.arn
}

output "cluster_id" {
  description = "ID of the cluster"
  value       = aws_rds_cluster.rds_cluster.id
}

output "cluster_port" {
  description = "Port of the cluster"
  value       = aws_rds_cluster.rds_cluster.port
}

output "cluster_instances" {
  description = "Instances in the cluster"
  value       = aws_rds_cluster.rds_cluster.cluster_members
}

output "read_username" {
  description = "Username for the read only user"
  value       = var.reader_username
}

output "read_password" {
  description = "Password for the read only user"
  value       = random_password.read_password.result
}

output "write_username" {
  description = "Username for the write user"
  value       = var.writer_username
}

output "write_password" {
  description = "Password for the write user"
  value       = random_password.write_password.result
}
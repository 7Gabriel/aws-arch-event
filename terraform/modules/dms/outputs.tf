output "replication_instance_arn" {
  value = aws_dms_replication_instance.dms_instance.replication_instance_arn
}

output "source_endpoint_arn" {
  value = aws_dms_endpoint.source_endpoint.endpoint_arn
}

output "destination_endpoint_arn" {
  value = aws_dms_endpoint.destination_endpoint.endpoint_arn
}

output "replication_task_arn" {
  value = aws_dms_replication_task.replication_task.replication_task_arn
}

resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_id    = var.replication_instance_id
  replication_instance_class = var.replication_instance_class
  allocated_storage          = var.allocated_storage
  publicly_accessible        = var.publicly_accessible
  engine_version             = var.engine_version
  tags                       = var.tags
  vpc_security_group_ids     = var.vpc_security_group_ids
  availability_zone          = "us-east-1a"
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnet_group.id
}

resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id = "dms-subnet-group"
  replication_subnet_group_description = "Subnet group for DMS"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "dms-subnet-group"
  }
}

resource "aws_dms_endpoint" "source_endpoint" {
  endpoint_id    = var.source_endpoint_id
  endpoint_type  = "source"
  engine_name    = var.source_engine_name
  server_name    = var.source_server_name
  username       = var.source_username
  password       = var.source_password
  database_name  = var.source_database_name
  port           = var.source_port
  ssl_mode       = var.source_ssl_mode
}

resource "aws_dms_endpoint" "destination_endpoint" {
  endpoint_id   = var.destination_endpoint_id
  endpoint_type = "target"
  engine_name   = "kinesis"
  kinesis_settings {
    stream_arn            = var.destination_stream_arn
    message_format        = var.destination_message_format
    service_access_role_arn = var.destination_service_access_role_arn
  }
}

resource "aws_dms_replication_task" "replication_task" {
  replication_task_id       = var.replication_task_id
  replication_task_settings = file("${path.module}/replication-settings.json")
  source_endpoint_arn       = aws_dms_endpoint.source_endpoint.endpoint_arn
  target_endpoint_arn       = aws_dms_endpoint.destination_endpoint.endpoint_arn
  migration_type            = var.migration_type
  table_mappings            = file("${path.module}/table-mappings.json")
  replication_instance_arn  = aws_dms_replication_instance.dms_instance.replication_instance_arn
  tags                      = var.tags
}

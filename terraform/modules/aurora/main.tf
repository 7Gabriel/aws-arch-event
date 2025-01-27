resource "aws_rds_cluster" "aurora" {
  engine        = "aurora-mysql"
  engine_mode   = "provisioned"
  engine_version = "8.0.mysql_aurora.3.05.2"
  cluster_identifier = "ecommerce-aurora-cluster"
  database_name = "ecommerce"
  master_username = var.master_username
  master_password = var.master_password
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  deletion_protection  = false
  skip_final_snapshot = false
  final_snapshot_identifier = "ecommerce-aurora-cluster-snapshot"
  
  tags = {
    Name = "ecommerce-aurora-cluster"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "aurora-subnet-group"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                 = var.instance_count
  identifier            = "${var.cluster_identifier}-instance-${count.index + 1}"
  cluster_identifier    = aws_rds_cluster.aurora.id
  instance_class        = var.instance_class
  engine                = aws_rds_cluster.aurora.engine
  publicly_accessible   = false

  tags = var.tags
}

output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "aurora_cluster_arn" {
  value = aws_rds_cluster.aurora.arn
}

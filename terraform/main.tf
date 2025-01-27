module "vpc" {
  source = "./modules/vpc"

  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  vpc_cidr              = "10.0.0.0/16"
}

module "kinesis" {
  source      = "./modules/kinesis"
  stream_name = "PedidosStream"
  shard_count = 1
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  table_name  = "Inventario"
  hash_key    = "ProdutoID"
  range_key   = "DataAtualizacao"
}

module "sns" {
  source     = "./modules/sns"
  topic_name = "ClienteNotificacao"
}

module "eventbridge" {
  source                     = "./modules/eventbridge"
  bus_name                   = "EcommerceEventBus"
  target_arn                 = module.lambda_processar_pedido.lambda_arn
  lambda_execution_role_name = module.iam_role.role_name
  function_name              = "ProcessarPedido"
}

module "aurora" {
  source                = "./modules/aurora"
  cluster_identifier    = "ecommerce-aurora-cluster"
  engine                = "aurora-mysql"
  engine_mode           = "provisioned"
  master_username       = "admin"
  master_password       = "Autogerenciada"
  database_name         = "ecommerce"
  backup_retention_period = 7
  deletion_protection   = false
  availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
  instance_count        = 2
  instance_class        = "db.t3.medium"
  private_subnet_ids    = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  vpc_id                = module.vpc.vpc_id
  tags = {
    Environment = "Dev"
  }
}

module "iam_role" {
  source    = "./modules/iam_role"
  role_name = "lambda_execution_role"

  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
}

module "lambda_processar_pedido" {
  source = "./modules/lambda"

  lambda_zip_path = "./lambdas/processar_pedido/processar_pedido.zip"
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group_ids             = [module.vpc.default_security_group_id]
  function_name         = "ProcessarPedido"
  runtime               = "python3.10"
  handler               = "processar_pedido.lambda_handler"
  role_arn              = module.iam_role.role_arn
  filename              = "${path.module}/lambdas/processar_pedido/processar_pedido.zip"
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
  environment_variables = {
    EVENT_BUS_NAME = module.eventbridge.cloudwatch_bus_arn
  }
  trigger_principal     = "kinesis.amazonaws.com"
  trigger_source_arn    = module.kinesis.kinesis_stream_arn
  lambda_execution_role_arn  = module.iam_role.role_arn
  event_bus_arn              = module.eventbridge.event_bus_arn
  bus_name                = module.eventbridge.bus_name
}


module "lambda_atualizar_estoque" {
  source = "./modules/lambda"

  lambda_zip_path = "./lambdas/atualizar_estoque/atualizar_estoque.zip"
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group_ids             = [module.vpc.default_security_group_id]
  function_name         = "AtualizarEstoque"
  runtime               = "python3.10"
  handler               = "atualizar_estoque.lambda_handler"
  role_arn              = module.iam_role.role_arn
  filename              = "${path.module}/lambdas/atualizar_estoque/atualizar_estoque.zip"
  environment_variables = {
    TABLE_NAME = module.dynamodb.dynamodb_table_arn
  }
  trigger_principal     = "events.amazonaws.com"
  trigger_source_arn    = module.eventbridge.cloudwatch_bus_arn
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
  lambda_execution_role_arn  = module.iam_role.role_arn
  event_bus_arn              = module.eventbridge.event_bus_arn
  bus_name                = module.eventbridge.bus_name
}


module "lambda_notificar_cliente" {
  source = "./modules/lambda"

  lambda_zip_path = "./lambdas/notificar_cliente/notificar_cliente.zip"
  subnet_ids                     = module.vpc.private_subnet_ids
  security_group_ids             = [module.vpc.default_security_group_id]
  function_name         = "NotificarCliente"
  runtime               = "python3.10"
  handler               = "notificar_cliente.lambda_handler"
  role_arn              = module.iam_role.role_arn
  filename              = "${path.module}/lambdas/notificar_cliente/notificar_cliente.zip"
  environment_variables = {
    SNS_TOPIC_ARN = module.sns.sns_topic_arn
  }
  trigger_principal     = "events.amazonaws.com"
  trigger_source_arn    = module.eventbridge.cloudwatch_bus_arn
  kinesis_stream_arn = module.kinesis.kinesis_stream_arn
  lambda_execution_role_arn  = module.iam_role.role_arn
  event_bus_arn              = module.eventbridge.event_bus_arn
  bus_name                = module.eventbridge.bus_name
}

module "iam_kinesis" {
  source    = "./modules/iam_kinesis"
  role_name = "dms-kinesis-access-role"
}

resource "aws_iam_role" "dms_vpc_role" {
  name = "dms-vpc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "dms.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "dms_vpc_management_policy" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}


resource "aws_iam_role_policy_attachment" "dms_kinesis_access" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}


resource "aws_iam_role_policy_attachment" "dms_s3_access" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}




resource "aws_iam_policy" "dms_logging_policy" {
  name        = "DMSLoggingPolicy"
  description = "Permissões para logs do DMS no CloudWatch e S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action: [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource: "arn:aws:logs:*:*:*"
      },
      {
        Effect: "Allow",
        Action: [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource: "arn:aws:s3:::dms-logs-bucket/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_logging_policy_attachment" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = aws_iam_policy.dms_logging_policy.arn
}

module "iam_dms" {
  source = "./modules/iam_dms"
}

module "dms" {
  source = "./modules/dms"

  private_subnet_ids         = module.vpc.private_subnet_ids
  vpc_security_group_ids     = [module.vpc.default_security_group_id]
  vpc_id                   = module.vpc.vpc_id
  replication_instance_id    = "dms-replication-instance"
  replication_instance_class = "dms.c5.12xlarge"
  allocated_storage          = 100
  publicly_accessible        = false
  engine_version             = "3.5.4"

  source_endpoint_id         = "aurora-source-endpoint"
  source_engine_name         = "mysql"
  source_server_name         = module.aurora.aurora_cluster_endpoint
  source_username            = "admin"
  source_password            = "Autogerenciada"
  source_database_name       = "ecommerce"
  source_port                = 3306
  source_ssl_mode            = "none"

  destination_endpoint_id           = "kinesis-destination-endpoint"
  destination_stream_arn            = module.kinesis.kinesis_stream_arn
  destination_message_format        = "json"
  destination_service_access_role_arn = aws_iam_role.dms_vpc_role.arn

  replication_task_id      = "aurora-to-kinesis"
  migration_type           = "cdc"

  tags = {
    Environment = "Dev"
  }
}


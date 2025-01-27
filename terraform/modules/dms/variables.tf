variable "replication_instance_id" {
  type        = string
  description = "Identificador da instância de replicação"
}

variable "replication_instance_class" {
  type        = string
  description = "Classe da instância de replicação"
}

variable "allocated_storage" {
  type        = number
  description = "Armazenamento alocado para a instância de replicação"
}

variable "publicly_accessible" {
  type        = bool
  description = "Se a instância de replicação será acessível publicamente"
}

variable "engine_version" {
  type        = string
  description = "Versão do motor da instância de replicação"
}

variable "source_endpoint_id" {
  type        = string
  description = "ID do endpoint de origem"
}

variable "source_engine_name" {
  type        = string
  description = "Nome do motor de origem"
}

variable "source_server_name" {
  type        = string
  description = "Nome do servidor de origem"
}

variable "source_username" {
  type        = string
  description = "Nome de usuário do banco de origem"
}

variable "source_password" {
  type        = string
  description = "Senha do banco de origem"
}

variable "source_database_name" {
  type        = string
  description = "Nome do banco de origem"
}

variable "source_port" {
  type        = number
  description = "Porta do banco de origem"
}

variable "source_ssl_mode" {
  type        = string
  description = "Modo SSL para o banco de origem"
}

variable "destination_endpoint_id" {
  type        = string
  description = "ID do endpoint de destino"
}

variable "destination_stream_arn" {
  type        = string
  description = "ARN do Kinesis Stream de destino"
}

variable "destination_message_format" {
  type        = string
  description = "Formato da mensagem enviada para o Kinesis"
}

variable "destination_service_access_role_arn" {
  type        = string
  description = "ARN da role IAM para acesso ao Kinesis"
}

variable "replication_task_id" {
  type        = string
  description = "ID da tarefa de replicação"
}

variable "migration_type" {
  type        = string
  description = "Tipo de migração (cdc, full-load, etc.)"
}

variable "tags" {
  type        = map(string)
  description = "Tags aplicadas aos recursos"
}

variable "private_subnet_ids" {
  description = "IDs das sub-redes privadas da VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID da VPC associada ao DMS"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "IDs dos grupos de segurança da VPC"
  type        = list(string)
}

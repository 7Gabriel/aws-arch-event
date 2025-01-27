variable "function_name" {
  type        = string
  description = "Nome da função Lambda"
}

variable "runtime" {
  type        = string
  default     = "python3.10"
  description = "Ambiente de execução da Lambda"
}

variable "handler" {
  type        = string
  description = "Handler da função Lambda (ex.: arquivo.handler)"
}

variable "role_arn" {
  type        = string
  description = "ARN da Role do IAM associada à Lambda"
}

variable "filename" {
  type        = string
  description = "Caminho do pacote zip da função Lambda"
}

variable "subnet_ids" {
  description = "Subnets onde a Lambda será executada"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups associados à Lambda"
  type        = list(string)
}

variable "environment_variables" {
  description = "Variáveis de ambiente para a Lambda"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  type        = number
  default     = 15
  description = "Tempo limite da execução da função Lambda (em segundos)"
}

variable "trigger_principal" {
  type        = string
  description = "Principal que pode invocar a função Lambda"
}

variable "trigger_source_arn" {
  type        = string
  description = "ARN do recurso que aciona a função Lambda"
}

variable "lambda_zip_path" {
  description = "Caminho do arquivo ZIP da função Lambda"
}

variable "kinesis_stream_arn" {
  description = "ARN do stream Kinesis associado à Lambda"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "ARN da role de execução da Lambda"
  type        = string
}

variable "event_bus_arn" {
  description = "ARN do EventBridge Event Bus"
  type        = string
}

variable "bus_name" {
  type        = string
  description = "Nome do Event Bus do EventBridge"
}